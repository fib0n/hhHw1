#!/bin/bash
grep -rli --include='*.log' "error" . | tee new.txt | sed 's/.*/"&"/' |xargs stat -f "%N %z bytes"
