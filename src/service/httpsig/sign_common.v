module httpsig

import net.http

@[params]
pub struct HttpsigConfig {
pub:
	method       http.Method @[required]
	uri          string      @[required]
	accept       string
	content_type string
	body         []u8 @[required]
}
