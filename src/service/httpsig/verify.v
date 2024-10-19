module httpsig

import net.http

@[params]
pub struct HttpsigInput {
pub:
	method       http.Method @[required]
	path         string      @[required]
	headers      http.Header
	body         []u8 @[required]
	pass_unknown bool
}

pub fn verify_headers(params HttpsigInput) ! {
	if params.headers.contains_custom('Signature-Input', exact: false) {
		verify_headers_rfc9421(params)!
	} else {
		verify_headers_cavage(params)!
	}
}
