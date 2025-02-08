module post

import markdown
import encoding.html
import rand
import time
import activitypub
import conf
import object

pub fn publish(summary string, post_md string) ! {
	body := md_to_html(post_md)

	root := conf.data.server.root
	now := time.utc().unix_milli()
	id := rand.ulid_at_millisecond(u64(now))
	post := object.Post{
		id:        id
		summary:   summary
		content:   body
		timestamp: now
		url:       '${root}/posts/${id}'
	}

	post.insert()!
	json := post.serialize()
	activitypub.deliver(json)!
}

fn md_to_html(md string) string {
	escaped := html.escape(md, quote: true) // Sanitize
	return markdown.to_html(escaped)
}
