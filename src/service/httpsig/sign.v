module httpsig

import net.http

@[params]
pub struct HttpsigConfig {
pub:
	method       http.Method @[required]
	uri          string      @[required]
	accept       string
	content_type string
	body         []u8
}

pub fn create_headers(params HttpsigConfig) !http.Header {
	httpsig_format := $d('httpsig', 'hybrid')
	return match httpsig_format {
		'cavage' { create_headers_cavage(params) }
		'rfc9421' { create_headers_rfc9421(params) }
		else { create_headers_hybrid(params) }
	}
}
