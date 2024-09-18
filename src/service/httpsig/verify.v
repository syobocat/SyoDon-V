module httpsig

import crypto.ed25519
import crypto.pem
import crypto.sha256
import encoding.base64
import net.http
import user

pub fn verify_header(method http.Method, header http.Header, dest_path string, body string, pass_unknown bool) ! {
	host := header.get(.host)!
	date := header.get(.date)!

	expected_data := match method {
		.get {
			$tmpl('templates/httpsig_get.txt')
		}
		.post {
			digest_base64 := header.get(.digest)!
			digest := base64.decode(digest_base64)
			expected_digest := sha256.sum256(body.bytes())
			if digest != expected_digest {
				return error('Wrong digest')
			}
			$tmpl('templates/httpsig_post.txt')
		}
		else {
			if pass_unknown {
				return
			}
			return error('Unknown method: ${method}')
		}
	}

	signature_header := header.get_custom('Signature', exact: false)!

	mut signature_map := map[string]string{}
	for field in signature_header.split(',') {
		key, value := field.split_once('=') or { return error('Invalid signature') }
		signature_map[key.trim(' "')] = value.trim(' "')
	}

	signature_base64 := signature_map['signature'] or { return error('Missing signature field') }
	signature := base64.decode(signature_base64)

	key_id := signature_map['keyId'] or { return error('Missing keyId field') }
	key_url := key_id.all_before_last('#')
	actor := user.get_actor_by_url(key_url)!
	pubkey_pem := actor.public_key.public_key_pem
	pubkey_block := pem.decode_only(pubkey_pem) or { return error('Invalid pem') }
	if pubkey_block.data.len != ed25519.public_key_size {
		if pass_unknown {
			return
		} else {
			return error('Unknown type of key')
		}
	}
	pubkey := ed25519.PublicKey(pubkey_block.data)

	if !ed25519.verify(pubkey, expected_data.bytes(), signature)! {
		return error('Wrong signature')
	}
}
