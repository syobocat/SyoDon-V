module server

import veb
import conf

@['/.well-known/nodeinfo']
fn (app &App) nodeinfo(mut ctx Context) veb.Result {
	root := conf.data.server.root

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('../templates/schemas/nodeinfo.json'))
}

@['/nodeinfo/2.0.json']
fn (app &App) nodeinfo_20(mut ctx Context) veb.Result {
	software_name := conf.data.software.name
	software_version := conf.data.software.version
	node_name := conf.data.server.name
	node_desc := conf.data.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('../templates/schemas/nodeinfo_2.0.json'))
}

@['/nodeinfo/2.1.json']
fn (app &App) nodeinfo_21(mut ctx Context) veb.Result {
	software_name := conf.data.software.name
	software_version := conf.data.software.version
	software_repo := conf.data.software.repo_url
	node_name := conf.data.server.name
	node_desc := conf.data.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('../templates/schemas/nodeinfo_2.1.json'))
}
