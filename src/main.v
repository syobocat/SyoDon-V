module main

import cli
import os
import server
import service.httpsig
import service.jobqueue

fn main() {
	mut app := cli.Command{
		name:     'SyoDoN'
		execute:  fn (cmd cli.Command) ! {
			spawn jobqueue.process()
			server.serve()
			return
		}
		commands: [
			cli.Command{
				name:    'init'
				execute: fn (cmd cli.Command) ! {
					initialize_database()
					return
				}
			},
			cli.Command{
				name:          'httpsig'
				required_args: 3
				execute:       fn (cmd cli.Command) ! {
					uri := cmd.args[0]
					content_type := cmd.args[1]
					body := cmd.args[2..].join(' ')
					sig := httpsig.create_headers(
						method:       .post
						uri:          uri
						content_type: content_type
						body:         body.bytes()
					)!
					println('POST /${uri.all_after_first('://').after_char(`/`)} HTTP/1.1')
					println(sig.str())
					println(body)
				}
			},
		]
	}
	app.setup()
	app.parse(os.args)
}
