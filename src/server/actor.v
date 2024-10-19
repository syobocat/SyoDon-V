module server

import crypto.pem
import veb

@['/actor']
fn (data &Data) actor(mut ctx Context) veb.Result {
	root := data.server.root
	actor_url := data.user.actor_url
	acct := data.user.acct

	pubkey := data.user.privkey.public_key()
	block := pem.Block{
		block_type: 'PUBLIC KEY'
		data:       pubkey
	}
	pubkey_pem := block.encode() or { return ctx.server_error('Internal Server Error') }.replace('\n',
		'\\n')

	ctx.set_content_type('application/activity+json; charset=utf-8')
	return ctx.ok($tmpl('templates/actor.json'))
}
