#!/bin/bash
# ----------------------------------------
# 0.set_scenario3_env.sh
# VWS 시나리오 1-3 실습환경 설정 스크립트 
# ----------------------------------------

# 1. 서버 설정 변경
ln -sf /usr/share/zoneinfo/UTC /etc/localtime > /dev/null 2>&1
ssh cent2 "ln -sf /usr/share/zoneinfo/UTC /etc/localtime" > /dev/null 2>&1
ssh cent3 "ln -sf /usr/share/zoneinfo/UTC /etc/localtime" > /dev/null 2>&1

# Nginx 에 반영
/usr/sbin/nginx -s reload > /dev/null 2>&1

# 2. DB에 데이터 생성
ssh cent2 <<'EOF' > /dev/null 2>&1
mysql -uroot <<'EOSQL'
SET GLOBAL time_zone = '+00:00';
SET time_zone = '+00:00';
DROP DATABASE IF EXISTS vws_service;
CREATE DATABASE vws_service;
USE vws_service;

CREATE TABLE user_activity (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50),
  action VARCHAR(255),
  ip_address VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO user_activity (username, action, ip_address) VALUES
('jihun', '게시글 작성', '172.18.1.23'),
('soyeon', '댓글 작성', '172.18.1.54'),
('mingu', '프로필 수정', '172.18.1.77'),
('kihyun', '로그인 성공', '172.18.1.32'),
('admin', '공지사항 등록', '172.18.1.10'),
('jihun', '로그아웃', '172.18.1.23');
EOSQL
EOF

# 3. 웹서버 로그 생성
for i in {1..5}; do
  wget -q -O /dev/null http://localhost/index.html
  sleep 1
  curl -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36" \
  http://localhost/index.html > /dev/null 2>&1
  sleep 1
done

# 4. 완료 메시지
echo
echo "---------------------------------------------------"
echo "설정 완료!"
echo "1.check_env.sh 를 실행해주세요."
echo "---------------------------------------------------"
echo

