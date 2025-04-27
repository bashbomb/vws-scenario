#!/bin/bash

DATE=$(/bin/date +%F)
LOG_FILE="/var/log/backup_${DATE}.log"

LOG_DIR="/mnt/backup/logs/${DATE}"
WEB_DIR="/mnt/backup/web_src/${DATE}"
CONFIG_DIR="/mnt/backup/config/${DATE}"

{
  echo "[$(/bin/date '+%Y-%m-%d %T')] 백업 스크립트 시작"

  # /mnt 마운트
  /bin/mount /mnt

  # 백업 디렉터리 생성
  /bin/mkdir -p "${LOG_DIR}" "${WEB_DIR}" "${CONFIG_DIR}"

  # 웹 소스 백업
  /bin/tar czf "${WEB_DIR}/html.tar.gz" -C /usr/share/nginx/html .
  echo "[$(/bin/date '+%Y-%m-%d %T')] 웹 소스 백업 완료"

  # 설정 파일 백업
  /bin/tar czf "${CONFIG_DIR}/nginx_config.tar.gz" -C /etc/nginx .
  echo "[$(/bin/date '+%Y-%m-%d %T')] 설정 파일 백업 완료"

  # 로그 파일 백업
  /bin/tar czf "${LOG_DIR}/nginx_logs.tar.gz" -C /var/log/nginx .
  /bin/grep error /var/log/messages > "${LOG_DIR}/messages.log"
  echo "[$(/bin/date '+%Y-%m-%d %T')] 로그 파일 백업 완료"

  # /mnt 마운트 해제
  /bin/umount /mnt
  echo "[$(/bin/date '+%Y-%m-%d %T')] /mnt 마운트 해제 완료"

  echo "[$(/bin/date '+%Y-%m-%d %T')] 백업 스크립트 종료"
} >> "${LOG_FILE}" 2>&1
