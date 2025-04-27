#!/bin/bash

# 0.set_scenario4_env.sh
# VWS 시나리오 1-4 실습환경 설정 스크립트

echo
echo "---------------------------------------------------"
echo " Virtual Web Service - 시나리오 1-4 환경 설정"
echo " 현재 cent1에서 전체 서버 준비 작업을 진행합니다."
echo "---------------------------------------------------"
echo

# 1. nginx 설정 파일 교체
echo "[1/4] nginx 설정을 적용합니다."
cp -f ./nginx_scenario4.conf /etc/nginx/nginx.conf
nginx -s reload

# 2. 로그 디렉터리 생성
echo "[2/4] 로그 디렉터리를 준비합니다."
mkdir -p /usr/local/nginx/logs

# 3. access.log 준비
echo "[3/4] 로그 파일을 준비합니다. (약 1~2분 소요됩니다. 잠시 기다려주세요.)"
touch /usr/local/nginx/logs/VWS.error.log
LOG_FILE="/usr/local/nginx/logs/VWS.access.log"
> "${LOG_FILE}"

# 초기 1000줄 생성
echo
echo "초기 로그 생성 중..."
START_DATE=$(date -d "-7 days" "+%d/%b/%Y:00:00:00 +0900")
CURRENT_TIME=$(date -d "-7 days" "+%s")

for i in $(seq 1 1000); do
  LOG_TIME=$(date -d "@${CURRENT_TIME}" "+%d/%b/%Y:%H:%M:%S +0900")
  echo "192.168.0.$((RANDOM%255)) - - [${LOG_TIME}] \"GET /index.html HTTP/1.1\" 200 1024 \"-\" \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36\"" >> "${LOG_FILE}"
  CURRENT_TIME=$((CURRENT_TIME + 2))

  if (( i % 50 == 0 )); then
    PERCENT=$(( i / 10 ))
    printf "\r진행 중: %3d%%" "${PERCENT}"
  fi
done
echo
echo "초기 로그 생성 완료."

# 1GB 더미파일 추가
dd if=/dev/zero of=dummyfile bs=1M count=1024 status=none
cat dummyfile >> "${LOG_FILE}"
rm -f dummyfile

# 마지막 1000줄 생성
echo
echo "추가 로그 생성 중..."
for i in $(seq 1 1000); do
  LOG_TIME=$(date -d "@${CURRENT_TIME}" "+%d/%b/%Y:%H:%M:%S +0900")
  echo "192.168.0.$((RANDOM%255)) - - [${LOG_TIME}] \"POST /login HTTP/1.1\" 200 2048 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36\"" >> "${LOG_FILE}"
  CURRENT_TIME=$((CURRENT_TIME + 2))

  if (( i % 50 == 0 )); then
    PERCENT=$(( i / 10 ))
    printf "\r진행 중: %3d%%" "${PERCENT}"
  fi
done
echo
echo "추가 로그 생성 완료."

# 4. 백그라운드 지속적인 웹로그 생성
echo "[4/4] 웹로그 생성을 시작합니다."
(
  USER_AGENTS=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36"
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36"
  )

  for i in $(seq 1 5000); do
    RANDOM_IP="192.168.$((RANDOM % 256)).$((RANDOM % 256))"
    UA=${USER_AGENTS[$((RANDOM % ${#USER_AGENTS[@]}))]}
    wget --header="X-Forwarded-For: ${RANDOM_IP}" --user-agent="${UA}" -q -O /dev/null http://localhost/index.html
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

