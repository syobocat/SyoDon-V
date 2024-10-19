module httpsig

import crypto.sha512
import encoding.base64
import net.http
import net.urllib
import time
import conf

pub fn create_headers(params HttpsigConfig) !http.Header {
	mut headers := http.Header{}

	data := &conf.data

	method := params.method.str().to_lower()

	dest := urllib.parse(params.uri)!
	dest_host := dest.host
	dest_path := dest.path

	date_now := time.now().local_to_utc()
	date := date_now.http_header_string()

	has_body := params.body.len > 0
	digest_base64 := if has_body {
		digest := sha512.sum512(params.body)
		base64.encode(digest)
	} else {
		''
	}

	actor_url := data.user.actor_url

	signature_base := $tmpl('templates_cavage/signature-base.txt').trim_space_right()

	privkey := data.user.privkey
	signature := privkey.sign(signature_base.bytes())!
	signature_base64 := base64.encode(signature)

	signature_string := $tmpl('templates_cavage/httpsig_signature.txt').trim_space_right()

	headers.add(.host, dest_host)
	headers.add(.date, date)
	if params.accept.len > 0 {
		headers.add(.accept, params.accept)
	}
	if params.content_type.len > 0 {
		headers.add(.content_type, params.content_type)
	}
	headers.add_custom('Signature', signature_string)!

	return headers
}
