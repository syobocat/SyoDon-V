module server

import veb
import conf

struct Context {
	veb.Context
}

pub struct App {}

pub fn serve() {
	mut app := &App{}
	veb.run_at[App, Context](mut app, veb.RunParams{
		family: .ip
		port:   conf.data.server.port
	}) or { panic(err) }
}
