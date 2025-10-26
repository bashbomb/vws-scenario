#!/bin/bash

# 0.set_scenario2_env.sh
# VWS 시나리오 1-2 실습환경 설정 스크립트

# 1. 기존 vwswebdb 유저가 있으면 삭제
mysql -uroot mysql -e "DROP USER IF EXISTS 'vwswebdb'@'localhost';" > /dev/null 2>&1

# 2. vwswebdb 유저 생성
mysql -uroot mysql -e "CREATE USER 'vwswebdb'@'localhost' IDENTIFIED BY 'thanksVWSis4u';" > /dev/null 2>&1

# 3. 권한 부여 및 적용
mysql -uroot mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'vwswebdb'@'localhost';" > /dev/null 2>&1
mysql -uroot mysql -e "FLUSH PRIVILEGES;" > /dev/null 2>&1

echo
echo "---------------------------------------------------"
echo " 설정 완료! cent2에서 DB 접속 테스트를 진행하세요."
echo " (DB USER: vwswebdb / PW: thanksVWSis4u)"
echo "---------------------------------------------------"
echo
