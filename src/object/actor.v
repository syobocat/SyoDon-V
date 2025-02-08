module object

import conf
// import time

pub struct Actor {
pub:
	id              string @[primary]
	acct            string
	name            ?string
	avatar_url      ?string
	bio             ?string
	first_seen      i64
	created_at      i64
	followers_count u32
	following_count u32
	posts_count     u32
}

pub fn (actor Actor) insert() ! {
	sql conf.data.server.db {
		insert actor into Actor
	}!
}
