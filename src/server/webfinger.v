module server

import vweb

@['/.well-known/webfinger']
fn (mut ctx Context) webfinger() vweb.Result {
	resource := ctx.query['resource'] or { return ctx.not_found() }

	root := ctx.data.server.root
	acct := ctx.data.user.acct_full
	actor_url := ctx.data.user.actor_url
	profile_url := ctx.data.user.profile_url

	if resource !in [
		'acct:${acct}',
		actor_url,
		profile_url,
		root,
		'${root}/',
		'${root}/${ctx.data.user.acct}',
	] {
		return ctx.not_found()
	}

	ctx.set_content_type('application/jrd+json; charset=utf-8')
	return ctx.ok($tmpl('templates/webfinger.json'))
}
