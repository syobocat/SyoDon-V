module main

import cli
import os
import server

fn main() {
	mut app := cli.Command{
		name:    'SyoDoN'
		execute: fn (cmd cli.Command) ! {
			server.serve()
			return
		}
	}
	app.setup()
	app.parse(os.args)
}
