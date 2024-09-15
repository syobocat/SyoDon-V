#!/usr/bin/env -S v

src_path := 'src/server'

files := ls(join_path_single(src_path, '_templates'))!

for file in files {
	target := join_path(src_path, '_templates', file)
	dest := join_path(src_path, 'templates', file)
	
	if exists(dest) {
		rm(dest)!
	}
	res := execute('jq -Sc . ${target}')
	
	mut f := create(dest)!
	f.write_string(res.output)!
	f.close()
}
