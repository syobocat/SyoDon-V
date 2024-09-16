module server

import veb

@['/.well-known/nodeinfo']
fn (data &Data) nodeinfo(mut ctx Context) veb.Result {
	root := data.server.root

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo.json'))
}

@['/nodeinfo/2.0.json']
fn (data &Data) nodeinfo_20(mut ctx Context) veb.Result {
	software_name := data.software.name
	software_version := data.software.version
	node_name := data.server.name
	node_desc := data.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo_2.0.json'))
}

@['/nodeinfo/2.1.json']
fn (data &Data) nodeinfo_21(mut ctx Context) veb.Result {
	software_name := data.software.name
	software_version := data.software.version
	software_repo := data.software.repo_url
	node_name := data.server.name
	node_desc := data.server.desc

	ctx.set_content_type('application/json; charset=utf-8')
	return ctx.ok($tmpl('templates/nodeinfo_2.1.json'))
}
