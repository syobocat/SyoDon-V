module server

import vweb

@['/.well-known/nodeinfo']
fn (mut ctx Context) nodeinfo() vweb.Result {
	root := ctx.data.server.root

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo.json'))
}

@['/nodeinfo/2.0.json']
fn (mut ctx Context) nodeinfo_20() vweb.Result {
	software_name := ctx.data.software.name
	software_version := ctx.data.software.version
	node_name := ctx.data.server.name
	node_desc := ctx.data.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo_2.0.json'))
}

@['/nodeinfo/2.1.json']
fn (mut ctx Context) nodeinfo_21() vweb.Result {
	software_name := ctx.data.software.name
	software_version := ctx.data.software.version
	software_repo := ctx.data.software.repo_url
	node_name := ctx.data.server.name
	node_desc := ctx.data.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo_2.1.json'))
}
