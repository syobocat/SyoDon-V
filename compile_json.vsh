#!/usr/bin/env -S v

src_path := 'src/templates'

files := ls(join_path_single(src_path, '_schemas'))!

for file in files {
	target := join_path(src_path, '_schemas', file)
	dest := join_path(src_path, 'schemas', file)

	res := execute('jq -Sc . ${target}')

	mut f := create(dest)!
	f.write_string(res.output)!
	f.close()
}
