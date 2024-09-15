module server

import vweb

@['/.well-known/nodeinfo']
fn (mut ctx Context) nodeinfo() vweb.Result {
	root := ctx.data.root

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo.json'))
}

@['/nodeinfo/2.0.json']
fn (mut ctx Context) nodeinfo_20() vweb.Result {
	software_name := ctx.data.software_name
	software_version := ctx.data.software_version
	node_name := ctx.config.server.name
	node_desc := ctx.config.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo_2.0.json'))
}

@['/nodeinfo/2.1.json']
fn (mut ctx Context) nodeinfo_21() vweb.Result {
	software_name := ctx.data.software_name
	software_version := ctx.data.software_version
	software_repo := ctx.data.software_repo
	node_name := ctx.config.server.name
	node_desc := ctx.config.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo_2.1.json'))
}
