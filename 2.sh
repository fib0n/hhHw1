#!/bin/bash
pgrep -fl "127\.0\.0\.1" | grep -E "^[0-9]{5} " | cut -c 1-80 | sort -r
