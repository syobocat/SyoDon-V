module server

import v.vmod
import vweb
import conf

struct Data {
	software_name    string
	software_version string
	software_repo    string
	root             string
	acct_full        string
	actor_url        string
	profile_url      string
}

fn build_data() Data {
	config := &conf.config
	manifest := vmod.decode(@VMOD_FILE) or { panic(err) }
	return Data{
		software_name:    manifest.name
		software_version: manifest.version
		software_repo:    manifest.repo_url
		root:             'https://${config.server.host}'
		acct_full:        '${config.user.acct}@${config.server.host}'
		actor_url:        'https://${config.server.host}/actor'
		profile_url:      'https://${config.server.host}/profile'
	}
}

const data = build_data()

struct Context {
	vweb.Context
	config &conf.Config = &conf.config @[vweb_global]
	data   &Data        = &data        @[vweb_global]
}

pub fn serve() {
	vweb.run_at(&Context{}, vweb.RunParams{
		family: .ip
		port:   8080
	}) or { panic(err) }
}
