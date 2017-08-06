#!/bin/bash
rm files.md
ls | grep -v "scripts" | grep -v "README" | while read FILE; do
	file $FILE  | awk -F: '{print $1"\n>"$2"\n---"}' >> files.md
done;