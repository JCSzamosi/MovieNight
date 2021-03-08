#!/bin/bash

file='data/current_week.csv'
while IFS=$'\t' read hash ts
do
	print -v fn '%(%Y-%m-%d)T-%s' "$ts" "$(file##*/}"
	git cat-file -p "${hash}:${file}" > "$fn"
done < <(git log --reverse --format=$'%H\t%ct' -- "$file")
