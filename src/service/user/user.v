module user

import json
import net.http

struct WebFingerResponse {
	aliases []string
	links   []struct {
		href         string
		rel          string
		content_type string @[json: 'type']
	}
}

struct Actor {
pub:
	// TODO: Expand
	public_key struct {
	pub:
		id             string
		owner          string
		public_key_pem string @[json: 'publicKeyPem']
	} @[json: 'publicKey']
}

pub fn resolve_acct(acct string) !string {
	_, host := acct.rsplit_once('@') or { return error('Invalid acct') }
	resp := http.fetch(http.FetchConfig{
		url:    'https://${host}/.well-known/webfinger'
		method: .get
		header: http.new_header(http.HeaderConfig{
			key:   .accept
			value: 'application/jrd+json'
		})
		params: {
			'resource': 'acct:${acct}'
		}
	})!
	if resp.status_code >= 400 {
		return error('Failed to resolve acct: status code ${resp.status_code}')
	}

	user := json.decode(WebFingerResponse, resp.body)!

	link := user.links.filter(it.rel == 'self')[0] or { return error('Invalid user') }

	return link.href
}

pub fn get_actor_by_url(url string) !Actor {
	resp := http.fetch(http.FetchConfig{
		url:    url
		method: .get
		header: http.new_header(http.HeaderConfig{
			key:   .accept
			value: 'application/activity+json'
		})
	})!
	if resp.status_code >= 400 {
		return error('Failed to resolve acct: status code ${resp.status_code}')
	}

	actor := json.decode(Actor, resp.body)!

	return actor
}

pub fn get_actor_by_acct(acct string) !Actor {
	url := resolve_acct(acct)!
	actor := get_actor_by_url(url)!
	return actor
}
