module jobqueue

import log
import net.http
import time

interface Job {
	process() !
mut:
	retry_count u32
}

fn (job Job) retry() Job {
	mut new_job := job
	new_job.retry_count += 1
	return new_job
}

struct BaseJob {
mut:
	retry_count u32
}

struct DeliverJob {
	BaseJob
	request http.FetchConfig
}

fn (job DeliverJob) process() ! {
	http.fetch(job.request)!
}

const queue = chan Job{}

fn insert_job(job Job) {
	queue <- job
}

fn retry_job(job Job) {
	new_job := job.retry()
	sleep_duration := if new_job.retry_count < 18 {
		new_job.retry_count * new_job.retry_count * new_job.retry_count * new_job.retry_count * time.second
	} else {
		24 * time.hour
	}
	time.sleep(sleep_duration)
	insert_job(new_job)
}

pub fn process() {
	for {
		job := <-queue
		job.process() or {
			if job.retry_count > 50 {
				log.warn('Job failed. Discarding.')
			} else {
				log.warn('Job failed. Retrying...')
				spawn retry_job(job)
			}
		}
	}
}
