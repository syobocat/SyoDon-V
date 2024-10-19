module httpsig

import crypto.sha512
import encoding.base64
import net.http
import net.urllib
import time
import conf

fn create_headers_hybrid(params HttpsigConfig) !http.Header {
	mut headers := http.Header{}

	data := &conf.data

	method := params.method.str().to_lower()

	dest := urllib.parse(params.uri)!
	dest_host := dest.host
	dest_path := dest.path

	date_now := time.now().local_to_utc()
	date := date_now.http_header_string()
	date_posix := date_now.unix()

	accept := params.accept
	content_length := params.body.len
	content_type := params.content_type

	has_body := params.body.len > 0
	digest_base64 := if has_body {
		digest := sha512.sum512(params.body)
		base64.encode(digest)
	} else {
		''
	}

	actor_url := data.user.actor_url

	signature_params := $tmpl('templates_rfc9421/signature-params.txt').trim_space_right()
	signature_base_rfc9421 := $tmpl('templates_rfc9421/signature-base.txt').trim_space_right()
	signature_base_cavage := $tmpl('templates_cavage/signature-base.txt').trim_space_right()

	privkey := data.user.privkey
	signature_rfc9421 := privkey.sign(signature_base_rfc9421.bytes())!
	signature_base64_rfc9421 := base64.encode(signature_rfc9421)
	
	signature_cavage := privkey.sign(signature_base_cavage.bytes())!
	signature_base64 := base64.encode(signature_cavage)
	
	signature_string_cavage := $tmpl('templates_cavage/httpsig_signature.txt').trim_space_right()

	headers.add(.host, dest_host)
	headers.add(.date, date)
	if has_body {
		headers.add_custom('Digest', 'sha-512=${digest_base64}')!
		headers.add_custom('Content-Digest', 'sha-512=:${digest_base64}:')!
		headers.add(.content_length, '${content_length}')
	}
	if content_type.len > 0 {
		headers.add(.content_type, content_type)
	}
	if accept.len > 0 {
		headers.add(.accept, accept)
	}
	headers.add_custom('Signature-Input', 'sig=${signature_params}')!
	headers.add_custom('Signature', '${signature_string_cavage},sig=:${signature_base64_rfc9421}:')!

	return headers
}
