module server

import vweb

@['/.well-known/webfinger']
fn (mut ctx Context) webfinger() vweb.Result {
	resource := ctx.query['resource'] or { return ctx.not_found() }

	root := ctx.data.root
	acct := ctx.data.acct_full
	actor_url := ctx.data.actor_url
	profile_url := ctx.data.profile_url

	if resource !in [
		'acct:${acct}',
		actor_url,
		profile_url,
		root,
		'${root}/',
		'${root}/${ctx.config.user.acct}',
	] {
		return ctx.not_found()
	}

	ctx.set_content_type('application/jrd+json; charset=utf-8')
	return ctx.ok($tmpl('templates/webfinger.json'))
}
