#!/bin/bash

# 0.set_scenario4_env.sh
# VWS 시나리오 1-4 실습환경 설정 스크립트

# 1. nginx 설정 파일 교체
cp -f ./nginx_scenario4.conf /etc/nginx/nginx.conf
/usr/sbin/nginx -s reload

# 2. 로그 디렉터리 생성
mkdir -p /var/log/nginx

# 3. 로그 준비
touch /usr/local/nginx/logs/VWS.error.log
LOG_FILE="/usr/local/nginx/logs/VWS.access.log"
> "${LOG_FILE}"

# 초기 1000줄 생성
START_DATE=$(date -d "-7 days" "+%d/%b/%Y:00:00:00 +0900")
CURRENT_TIME=$(date -d "-7 days" "+%s")

for i in $(seq 1 1000); do
  LOG_TIME=$(date -d "@${CURRENT_TIME}" "+%d/%b/%Y:%H:%M:%S +0900")
  echo "192.168.0.$((RANDOM%255)) - - [${LOG_TIME}] \"GET /index.html HTTP/1.1\" 200 1024 \"-\" \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36\"" >> "${LOG_FILE}"
  CURRENT_TIME=$((CURRENT_TIME + 2))

  if (( i % 50 == 0 )); then
    PERCENT=$(( i / 10 ))
    printf "\r페이즈1 진행 중: %3d%%" "${PERCENT}"
  fi
done

# 더미파일 추가
DUMMY="/usr/local/nginx/logs/dummyfile"
dd if=/dev/urandom of="${DUMMY}" bs=1M count=1024 status=progress
cat "${DUMMY}" >> "${LOG_FILE}"
rm -f "${DUMMY}"

# 마지막 1000줄 생성
for i in $(seq 1 1000); do
  LOG_TIME=$(date -d "@${CURRENT_TIME}" "+%d/%b/%Y:%H:%M:%S +0900")
  echo "192.168.0.$((RANDOM%255)) - - [${LOG_TIME}] \"POST /login HTTP/1.1\" 200 2048 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36\"" >> "${LOG_FILE}"
  CURRENT_TIME=$((CURRENT_TIME + 2))

  if (( i % 50 == 0 )); then
    PERCENT=$(( i / 10 ))
    printf "\r페이즈2 진행 중: %3d%%" "${PERCENT}"
  fi
done

# 4. 백그라운드 지속적인 웹로그 생성
(
  USER_AGENTS=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36"
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36"
  )

  for i in $(seq 1 5000); do
    RANDOM_IP="192.168.$((RANDOM % 256)).$((RANDOM % 256))"
    UA=${USER_AGENTS[$((RANDOM % ${#USER_AGENTS[@]}))]}
    #wget --header="X-Forwarded-For: ${RANDOM_IP}" --user-agent="${UA}" -q -O /dev/null http://localhost/index.html
    curl -s -A "${UA}" http://cent1/index.html --header "X-Forwarded-For: ${RANDOM_IP}" > /dev/null
    sleep 1
  done
) &

# 완료 안내
echo
echo "---------------------------------------------------"
echo "환경 설정이 완료되었습니다!"
echo "1.check_env.sh를 실행하여 환경을 점검하세요."
echo "---------------------------------------------------"
echo

