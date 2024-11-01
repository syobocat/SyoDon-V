module post

import markdown
import encoding.html
import rand
import time
import conf

pub fn publish(md string) ! {
	body := md_to_html(md)
	json := store(body)!
	deliver(json)!
}

pub fn store(post_html string) !string {
	root := &conf.data.server.root
	actor_url := &conf.data.user.actor_url
	now := time.utc()
	post_date := now.format_rfc3339_micro()
	post_id := rand.ulid_at_millisecond(u64(now.unix_milli()))

	post_summary := '' // TODO

	// TODO: Create database job

	json := $tmpl('../../templates/schemas/ap_note.json')
	return json
}

fn deliver(json string) ! {
	root := &conf.data.server.root
	actor_url := &conf.data.user.actor_url
	activity_id := rand.ulid()

	activity := $tmpl('../../templates/schemas/ap_create.json')

	// TODO: Create deliver job
}

fn md_to_html(md string) string {
	escaped := html.escape(md) // Sanitize
	return markdown.to_html(escaped)
}
