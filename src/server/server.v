module server

import veb
import conf

struct Context {
	veb.Context
}

pub struct Data {
	conf.Data
}

pub fn serve() {
	mut data := &Data{&conf.data}
	veb.run_at[Data, Context](mut data, veb.RunParams{
		family: .ip
		port:   data.server.port
	}) or { panic(err) }
}
