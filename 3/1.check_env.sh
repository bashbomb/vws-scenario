#!/bin/bash
# -----------------------------------------
# 1.check_env.sh
# VWS 시나리오 1-3 실습 환경 확인 스크립트
# -----------------------------------------

errors=0

# 1. 서버 설정 확인
for server in cent1 cent2 cent3; do
    TIMEZONE=$(ssh -o LogLevel=ERROR "${server}" 'date +"%Z"' 2>/dev/null | grep -Eo 'UTC|KST')
    if [[ "${TIMEZONE}" != "UTC" ]]; then
        echo "[WARN] ${server}: Timezone = ${TIMEZONE:-Unknown}"
        errors=$((errors+1))
    fi
done

# 2. DB 및 테이블 확인
ssh cent2 > /tmp/dbcheck.log 2>/dev/null <<'EOF'
mysql -uroot -N -s -e "
SHOW DATABASES LIKE 'vws_service';
USE vws_service;
SHOW TABLES LIKE 'user_activity';
"
EOF

grep -q "vws_service" /tmp/dbcheck.log || { echo "[WARN] DB 'vws_service' not found"; errors=$((errors+1)); }
grep -q "user_activity" /tmp/dbcheck.log || { echo "[WARN] Table 'user_activity' not found"; errors=$((errors+1)); }

# 3. Nginx 로그 파일 확인
[ -s /var/log/nginx/VWS.access.log ] || errors=$((errors+1))

#4. tmp 파일 삭제
rm -f /tmp/dbcheck.log

# 5. 결과 출력
if [ "${errors}" -eq 0 ]; then
    echo "실습 환경이 정상적으로 설정되었습니다. 시나리오를 진행하세요."
else
    echo "실습 환경 설정에 문제가 있습니다."
    echo "컨테이너를 재시작(docker-compose down & up)한 뒤, 다음 명령어를 다시 실행하세요:"
    echo "./0.set_scenario3_env.sh"
fi

