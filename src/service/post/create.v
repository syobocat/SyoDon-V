module post

import markdown
import encoding.html
import rand
import time
import conf
import jobqueue

struct Post {
	id      string
	summary string
	content string
	date    time.Time
	url     string
}

pub fn publish(summary string, post_md string) ! {
	body := md_to_html(post_md)

	root := conf.data.server.root
	now := time.utc()
	id := rand.ulid_at_millisecond(u64(now.unix_milli()))
	post := Post{
		id:      id
		summary: summary
		content: body
		date:    now
		url:     '${root}/posts/${id}'
	}
	store(post)
	json := serialize(post)
	deliver(json)!
}

pub fn store(post Post) {
	job := jobqueue.DatabaseJob{
		query:  'INSERT INTO posts VALUES(?, ?, ?, ?, ?, ${post.date.unix_micro()}, 0, 0, 0)'
		params: [post.id, '', post.content, post.url, post.summary]
	}

	spawn jobqueue.insert_job(job)
}

fn serialize(post Post) string {
	root := &conf.data.server.root
	actor_url := &conf.data.user.actor_url
	post_date := post.date.format_rfc3339_micro()
	post_id := rand.ulid_at_millisecond(u64(post.date.unix_milli()))
	post_summary := post.summary
	post_html := post.content

	json := $tmpl('../../templates/schemas/ap_note.json')
	return json
}

fn deliver(object string) ! {
	root := &conf.data.server.root
	actor_url := &conf.data.user.actor_url
	activity_id := rand.ulid()

	activity := $tmpl('../../templates/schemas/ap_create.json')

	// TODO: Create deliver job
}

fn md_to_html(md string) string {
	escaped := html.escape(md, quote: true) // Sanitize
	return markdown.to_html(escaped)
}
