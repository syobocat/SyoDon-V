module server

import veb

@['/schema'; get]
fn (app &App) schema(mut ctx Context) veb.Result {
	ctx.set_content_type('application/ld+json')
	return ctx.ok($embed_file('../templates/schemas/jsonld_contexts.json').to_string())
}
