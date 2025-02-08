module object

import conf
import time

pub struct Post {
pub:
	id              string @[primary]
	actor_id        ?string
	content         string
	url             string
	summary         ?string
	timestamp       i64
	favorites_count u32
	repeats_count   u32
	replies_count   u32
}

pub fn (post Post) insert() ! {
	sql conf.data.server.db {
		insert post into Post
	}!
}

pub fn (post Post) serialize() string {
	root := &conf.data.server.root
	actor_url := &conf.data.user.actor_url
	post_date := time.unix_milli(post.timestamp)
	post_id := post.id
	post_summary := post.summary
	post_html := post.content

	json := $tmpl('../templates/schemas/ap_note.json')
	return json
}
