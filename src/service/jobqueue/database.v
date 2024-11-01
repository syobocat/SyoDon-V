module jobqueue

import db.sqlite
import conf

struct DatabaseJob {
	BaseJob
	query string
}

fn (job DatabaseJob) process() ! {
	db := &conf.data.server.db
	res := db.exec_none(job.query)
	if sqlite.is_error(res) {
		return error('SQLite error: code ${res}')
	}
}
