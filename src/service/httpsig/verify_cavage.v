module httpsig

import crypto.ed25519
import crypto.pem
import crypto.sha256
import crypto.sha512
import encoding.base64
import user

pub fn verify_headers_cavage(params HttpsigInput) ! {
	method := params.method.str()
	dest_host := params.headers.get(.host)!
	dest_path := params.path
	date := params.headers.get(.date)!
	
	has_body := params.body.len > 0
	
	digest_base64 := params.headers.get(.digest) or { '' }.after_char(`=`)
	
	if has_body {
		digest := base64.decode(digest_base64)
		expected_digest_sha256 := sha256.sum256(params.body)
		expected_digest_sha512 := sha512.sum512(params.body)
		if digest != expected_digest_sha256 && digest != expected_digest_sha512 {
			return error('Wrong digest')
		}
	}
	
	// TODO (important): build signature base based on Signature header
	expected_data := $tmpl('templates_cavage/signature-base.txt')
	
	signature_header := params.headers.get_custom('Signature', exact: false)!
	
	mut signature_map := map[string]string{}
	for field in signature_header.split(',') {
		key, value := field.split_once('=') or { continue }
		signature_map[key.trim(' "')] = value.trim(' "')
	}
	
	algorithm := signature_map['algorithm'] or { '' }
	if algorithm == 'rsa-sha256' {
		if params.pass_unknown {
			return
		} else {
			return error("SyoDon-V doesn't support RSA keypair")
		}
	}
	
	signature_base64 := signature_map['signature'] or { return error('Missing signature field in Signature header') }
	signature := base64.decode(signature_base64)
	
	key_id := signature_map['keyId'] or { return error('Missing keyId field in Signature header') }
	key_url := key_id.all_before_last('#')
	actor := user.get_actor_by_url(key_url)!
	pubkey_pem := actor.public_key.public_key_pem
	pubkey_block := pem.decode_only(pubkey_pem) or { return error('Invalid pem') }
	if pubkey_block.data.len != ed25519.public_key_size {
		if params.pass_unknown {
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
