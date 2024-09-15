module conf

// import toml
import json
import os

pub struct Config {
pub:
	server ServerConfig @[required]
	user   UserConfig   @[required]
}

struct ServerConfig {
pub:
	host string @[required]
	name string = 'SyoDoN'
	desc string = 'A minimalistic ActivityPub implementation'
	bind string = '0.0.0.0'
	port int    = 3000
}

struct UserConfig {
pub:
	acct    string @[required]
	name    string = 'Nameless'
	privkey string @[required]
}

pub const config = read_config()

/*
fn Config.read() Config {
	config_toml := toml.parse_file('config.toml') or { panic('Failed to read config.toml: ${err}') }

	server := config_toml.value('server')
	user := config_toml.value('user')

	return Config{
		server: server.reflect[ServerConfig]()
		user:   user.reflect[UserConfig]()
	}
}
*/

fn read_config() Config {
	config_json := os.read_file('config.json') or { panic('Failed to read config.json: ${err}') }

	return json.decode(Config, config_json) or { panic('Failed to parse config.json: ${err}') }
}
