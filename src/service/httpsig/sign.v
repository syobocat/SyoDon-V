module httpsig

import crypto.sha512
import encoding.base64
import net.http
import net.urllib
import time
import conf

pub fn create_header(method http.Method, body string, dest_url string) !http.Header {
	mut headers := http.Header{}

	data := &conf.data

	host := data.server.host

	dest := urllib.parse(dest_url)!
	dest_path := dest.path

	date_now := time.now().local_to_utc()
	date := date_now.http_header_string()

	actor_url := data.user.actor_url
	privkey := data.user.privkey

	match method {
		.get {
			to_be_signed := $tmpl('templates/httpsig_get.txt')
			signature := privkey.sign(to_be_signed.bytes())!
			signature_base64 := base64.encode(signature)
			signature_string := $tmpl('templates/httpsig_signature_get.txt')

			headers.add_custom('Signature', signature_string)!
		}
		.post {
			digest := sha512.sum512(body.bytes())
			digest_base64 := base64.encode(digest)

			to_be_signed := $tmpl('templates/httpsig_post.txt')
			signature := privkey.sign(to_be_signed.bytes())!
			signature_base64 := base64.encode(signature)
			signature_string := $tmpl('templates/httpsig_signature_post.txt')

			headers.add(.digest, 'sha-512=${digest_base64}')
			headers.add_custom('Signature', signature_string)!
		}
		else {
			return error('Unknown method')
		}
	}

	headers.add(.host, dest.host)
	headers.add(.date, date)

	return headers
}
