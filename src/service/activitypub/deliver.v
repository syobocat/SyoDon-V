module activitypub

import rand
import conf

pub fn deliver(object string) ! {
	root := &conf.data.server.root
	actor_url := &conf.data.user.actor_url
	activity_id := rand.ulid()

	activity := $tmpl('../../templates/schemas/ap_create.json')

	// TODO: Create deliver job
}
