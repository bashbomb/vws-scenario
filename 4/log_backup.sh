#!/bin/bash
set -euo pipefail

dst_dir="/var/backup/nginx"
mkdir -p "${dst_dir}"

# 실행 시작 시각 (epoch)
start_time=$(date +%s)
duration=$((60 * 50))  # 50분(3000초)

# 병렬 I/O 백업 프로세스 시작
for i in {1..4}; do
  ionice -c2 -n0 dd if=/dev/zero of="${dst_dir}/nginx_log-$(date +%Y%m%d%H%M%S)-${i}.tgz" \
    bs=4K count=250000 oflag=dsync status=none &
done

# 50분 동안 실행
while true; do
  now=$(date +%s)
  elapsed=$(( now - start_time ))

  if [ "${elapsed}" -ge "${duration}" ]; then
    pkill -f "dd if=/dev/zero" || true
    break
  fi

  sync
  sleep 2
done
