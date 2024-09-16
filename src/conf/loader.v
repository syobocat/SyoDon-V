module conf

// import toml
import json
import os
import crypto.ed25519
import encoding.hex
import v.vmod

struct Config {
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
	acct         string @[required]
	name         string = 'Nameless'
	privkey_seed string @[required]
}

pub struct Data {
pub:
	software vmod.Manifest @[required]
	server   struct {
		ServerConfig
	pub:
		root string @[required]
	}
	user struct {
		UserConfig
	pub:
		acct_full   string             @[required]
		actor_url   string             @[required]
		profile_url string             @[required]
		privkey     ed25519.PrivateKey @[required]
	}
}

pub const data = read_config()

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

fn read_config() Data {
	config_json := os.read_file('config.json') or { panic('Failed to read config.json: ${err}') }
	config := json.decode(Config, config_json) or { panic('Failed to parse config.json: ${err}') }
	manifest := vmod.decode(@VMOD_FILE) or { panic(err) }
	privkey := ed25519.new_key_from_seed(hex.decode(config.user.privkey_seed) or { panic(err) })

	return Data{
		software: manifest
		server:   struct {
			ServerConfig: config.server
			root:         'https://${config.server.host}'
		}
		user: struct {
			UserConfig:  config.user
			acct_full:   '${config.user.acct}@${config.server.host}'
			actor_url:   'https://${config.server.host}/actor'
			profile_url: 'https://${config.server.host}/profile'
			privkey:     privkey
		}
	}
}
