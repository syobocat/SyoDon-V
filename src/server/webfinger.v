module server

import veb

@['/.well-known/webfinger']
fn (data &Data) webfinger(mut ctx Context) veb.Result {
	resource := ctx.query['resource'] or { return ctx.not_found() }

	root := data.server.root
	acct := data.user.acct_full
	actor_url := data.user.actor_url
	profile_url := data.user.profile_url

	if resource !in [
		'acct:${acct}',
		actor_url,
		profile_url,
		root,
		'${root}/',
		'${root}/${data.user.acct}',
	] {
		return ctx.not_found()
	}

	ctx.set_content_type('application/jrd+json; charset=utf-8')
	return ctx.ok($tmpl('templates/webfinger.json'))
}
