module jobqueue

import net.http

struct DeliverJob {
	BaseJob
	request http.FetchConfig
}

fn (job DeliverJob) process() ! {
	res := http.fetch(job.request)!
	if res.status().is_error() {
		return error(res.status_msg)
	}
}
