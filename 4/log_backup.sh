#!/bin/bash
set -euo pipefail

dst_dir="/var/backups/nginx"
mkdir -p "${dst_dir}"

for i in {1..4}; do
  ionice -c2 -n0 dd if=/dev/zero of="${dst_dir}/nginx_log-${i}-$(date +%s).tgz" \
    bs=4K count=250000 oflag=dsync status=none &
done

while true; do
  sync
  sleep 2
done

