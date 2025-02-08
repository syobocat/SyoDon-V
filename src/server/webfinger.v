module server

import conf
import veb

@['/.well-known/webfinger']
fn (app &App) webfinger(mut ctx Context) veb.Result {
	resource := ctx.query['resource'] or { return ctx.not_found() }

	root := conf.data.server.root
	acct := conf.data.user.acct_full
	actor_url := conf.data.user.actor_url
	profile_url := conf.data.user.profile_url

	if resource !in [
		'acct:${acct}',
		actor_url,
		profile_url,
		root,
		'${root}/',
		'${root}/${conf.data.user.acct}',
	] {
		return ctx.not_found()
	}

	ctx.set_content_type('application/jrd+json; charset=utf-8')
	return ctx.ok($tmpl('../templates/schemas/webfinger.json'))
}
