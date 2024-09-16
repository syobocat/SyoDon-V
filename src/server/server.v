module server

import vweb
import conf

struct Context {
	vweb.Context
	data &conf.Data = &conf.data @[vweb_global]
}

pub fn serve() {
	vweb.run_at(&Context{}, vweb.RunParams{
		family: .ip
		port:   8080
	}) or { panic(err) }
}
