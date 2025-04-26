#!/bin/bash

# 0.set_scenario3_env.sh
# VWS 시나리오 1-3 실습환경 설정 스크립트

echo
echo "---------------------------------------------------"
echo " Virtual Web Service - 시나리오 1-3 환경 설정"
echo " 현재 cent1에서 전체 서버 준비 작업을 진행합니다."
echo "---------------------------------------------------"
echo

# 1. 서버 시간대 조정
echo "[1/4] 서버 환경 초기 설정을 적용합니다."
ln -sf /usr/share/zoneinfo/UTC /etc/localtime > /dev/null 2>&1
ssh cent2 "ln -sf /usr/share/zoneinfo/UTC /etc/localtime" > /dev/null 2>&1
ssh cent3 "ln -sf /usr/share/zoneinfo/UTC /etc/localtime" > /dev/null 2>&1

# 2. DB 테스트 데이터 준비
echo "[2/4] 데이터베이스 초기 설정을 진행합니다."
ssh cent2 <<EOF > /dev/null 2>&1
mysql -uroot <<EOSQL
DROP DATABASE IF EXISTS vws_test;
CREATE DATABASE vws_test;
USE vws_test;
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO logs (log_message) VALUES ('샘플로그1'), ('샘플로그2');
EOSQL
EOF

# 3. 웹 로그 작성
echo "[3/4] 웹관련 초기 설정을 진행합니다. (10초 예상)"
for i in {1..5}; do
    wget -q -O /dev/null http://localhost/index.html
    sleep 1
    curl -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36" http://localhost/index.html > /dev/null 2>&1
    sleep 1
done

# 4. 설정 완료 메세지
echo "[4/4] 기본 환경 준비가 완료되었습니다."

echo
echo "---------------------------------------------------"
echo "설정 완료!"
echo "1.check_env.sh 를 실행해주세요."
echo "---------------------------------------------------"
echo
