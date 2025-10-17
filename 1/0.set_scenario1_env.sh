#!/bin/bash

# 0. 초기화
crontab -r
rm -f /usr/local/bin/backup.sh /dev/null 2>&1
pkill crond >/dev/null 2>&1

# 1. 로그 디렉토리 생성
mkdir -p /var/log/nginx
mount /mnt
mkdir -p /mnt/backup/logs

# 2. 샘플 로그 삽입
TODAY=$(date '+%b %d')
DATE=$(date '+%d/%b/%Y:%H:%M:%S %z')
{
echo "${TODAY} 00:00:01 localhost kernel: [    0.000000] Initializing cgroup subsys cpuset"
echo "${TODAY} 00:01:23 localhost systemd[1]: Started Daily Cleanup of Temporary Directories."
echo "${TODAY} 00:02:45 localhost sshd[1234]: error: PAM: Authentication failure for illegal user admin from 192.168.0.100"
} >> /var/log/messages
{
  echo '127.0.0.1 - - ['"${DATE}"'] "GET /index.html HTTP/1.1" 200 1024'
  echo '127.0.0.1 - - ['"${DATE}"'] "POST /login HTTP/1.1" 302 512'
  echo '192.168.0.5 - - ['"${DATE}"'] "GET /dashboard HTTP/1.1" 200 2048'
} >> /var/log/nginx/access.log
echo "${TODAY} 00:00:01 localhost CROND[2222]: (root) CMD (/usr/local/bin/backup.sh)" >> /var/log/cron

# 3. 백업 스크립트 배치
cp backup.sh /usr/local/bin/backup.sh
chmod +x /usr/local/bin/backup.sh

# 4. PATH 제한
echo -e "SHELL=/bin/bash\nPATH=/bin" > /etc/cron.d/0hourly

# 5. crontab 등록 (자정 실행)
( crontab -l 2>/dev/null; echo '0 0 * * * /usr/local/bin/backup.sh ' ) | crontab -

# 6. crond 실행
/usr/sbin/crond &
