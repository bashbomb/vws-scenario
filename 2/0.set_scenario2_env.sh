#!/bin/bash

# 0.set_scenario2_env.sh
# VWS 시나리오 1-2 실습환경 설정 스크립트

echo
echo "---------------------------------------------------"
echo " Virtual Web Service - 시나리오 1-2 환경 설정"
echo " 현재 cent2 서버에서 MariaDB 환경을 준비합니다."
echo "---------------------------------------------------"
echo

# 1. 기존 vwswebdb 유저가 있으면 삭제
echo "[1/3] 기존 vwswebdb 유저를 있으면 삭제합니다."
mysql -uroot mysql -e "DROP USER IF EXISTS 'vwswebdb'@'localhost';" > /dev/null 2>&1

# 2. vwswebdb 유저 생성 (localhost 전용)
echo "[2/3] 새로운 vwswebdb@localhost 유저를 생성합니다."
mysql -uroot mysql -e "CREATE USER 'vwswebdb'@'localhost' IDENTIFIED BY 'thanksVWSis4u';" > /dev/null 2>&1

# 3. 권한 부여 및 적용
echo "[3/3] 권한을 부여하고 설정을 반영합니다."
mysql -uroot mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'vwswebdb'@'localhost';" > /dev/null 2>&1
mysql -uroot mysql -e "FLUSH PRIVILEGES;" > /dev/null 2>&1

echo
echo "---------------------------------------------------"
echo " 설정 완료! cent1에서 DB 접속 테스트를 진행하세요."
echo " (ID: vwswebdb / PW: thanksVWSis4u)"
echo "---------------------------------------------------"
echo
