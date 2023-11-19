#!/usr/bin/env bash

output="./doc/README.md"
packages_list='packages.temp'

packages="$(
	rg '.*("([a-zA-Z0-9-_]+/[.a-zA-Z0-9-_]+)").*' \
		--glob='lua/plugins/*.lua' \
		--replace='$2' \
		--no-line-number \
		--no-filename | sort -uf
)"

sed -i '/| \[/d' "$output"

printf "\
=====  Getting description for each package  =====\n\
      =====  this might take a while  =====\n"

while LF='' read -r line; do
	description="$(gh repo view "$line" --json description --jq .description)"
	printf "| [%s](https://github.com/%s) | %s |\n" "$line" "$line" "$description" >>"$packages_list"

	gh api \
		--method PUT \
		-H "Accept: application/vnd.github+json" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		"/user/starred/$line"
done <<<"$packages"

sed -i "/^| -/ r $packages_list" "$output"

rm "$packages_list"

echo "󱓟 README updated 󱪚 "
