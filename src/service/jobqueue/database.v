module jobqueue

import conf

pub struct DatabaseJob {
	BaseJob
pub:
	query  string
	params []string
}

fn (job DatabaseJob) process() ! {
	db := &conf.data.server.db
	_ := db.exec_param_many(job.query, job.params)!
}
