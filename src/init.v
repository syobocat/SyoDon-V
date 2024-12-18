module main

import conf

fn initialize_database() {
	db := &conf.data.server.db
	println('Preparing database...')
	db.exec_none('
		CREATE TABLE IF NOT EXISTS posts (
			id              TEXT PRIMARY KEY,
			actor_id        TEXT NOT NULL,
			content         TEXT NOT NULL,
			url             TEXT NOT NULL,
			summary         TEXT,
			date            INTEGER NOT NULL,
			favorites_count INTEGER NOT NULL,
			repeats_count   INTEGER NOT NULL,
			replies_count   INTEGER NOT NULL
		)')
	db.exec_none('
		CREATE TABLE IF NOT EXISTS actors (
			id              TEXT PRIMARY KEY,
			acct            TEXT NOT NULL,
			name            TEXT,
			avatar_url      TEXT,
			bio             TEXT,
			first_seen_at   INTEGER NOT NULL,
			created_at      INTEGER,
			followers_count INTEGER NOT NULL,
			following_count INTEGER NOT NULL,
			posts_count     INTEGER NOT NULL
		)')
	db.exec_none('
		CREATE TABLE IF NOT EXISTS followings (
			id     TEXT PRIMARY KEY,
			outbox TEXT
		)')
	db.exec_none('
		CREATE TABLE IF NOT EXISTS followers (
			id    TEXT PRIMARY KEY,
			inbox TEXT NOT NULL
		)')
	db.exec_none('
		CREATE TABLE IF NOT EXISTS apps (
			client_id     TEXT PRIMARY KEY,
			client_secret TEXT NOT NULL,
			name          TEXT NOT NULL,
			redirect_uris TEXT NOT NULL,
			code          TEXT
		)')
	db.exec_none('
		CREATE TABLE IF NOT EXISTS token (
			token  TEXT PRIMARY KEY,
			issuer TEXT NOT NULL
		)')
	println('Database is ready.')
}
