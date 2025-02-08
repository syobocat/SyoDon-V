module server

import crypto.pem
import veb
import conf

@['/actor']
fn (app &App) actor(mut ctx Context) veb.Result {
	root := conf.data.server.root
	actor_url := conf.data.user.actor_url
	acct := conf.data.user.acct
	name := conf.data.user.name

	pubkey := conf.data.user.privkey.public_key()
	block := pem.Block{
		block_type: 'PUBLIC KEY'
		data:       pubkey
	}
	pubkey_pem := block.encode() or { return ctx.server_error('Internal Server Error') }.replace('\n',
		'\\n')

	ctx.set_content_type('application/activity+json; charset=utf-8')
	return ctx.ok($tmpl('../templates/schemas/ap_person.json'))
}
