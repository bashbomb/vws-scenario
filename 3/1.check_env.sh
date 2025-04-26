#!/bin/bash

# 1.check_env.sh
# VWS 시나리오 1-3 실습 환경 확인 스크립트

echo
echo "---------------------------------------------------"
echo " Virtual Web Service - 시나리오 1-3 환경 점검"
echo "---------------------------------------------------"
echo

RESULT_OK=true

# 1. 서버 시간대 체크
for server in cent1 cent2 cent3; do
    TIMEZONE=$(ssh "${server}" 'date +"%Z"' 2>/dev/null | grep -Eo 'UTC|KST')
    if [[ "${TIMEZONE}" != "UTC" ]]; then
        RESULT_OK=false
    fi
done

# 2. DB vws_test 존재 여부 체크 (motd 무시하고 결과만 필터링)
DB_CHECK=$(ssh cent2 "mysql -uroot -N -s -e \"SHOW DATABASES LIKE 'vws_test';\"" 2>/dev/null | grep -w "vws_test")
if [[ "${DB_CHECK}" != "vws_test" ]]; then
    RESULT_OK=false
fi

# 최종 결과 출력
echo
echo "---------------------------------------------------"
if [ "${RESULT_OK}" = true ]; then
    echo "실습 환경이 정상적으로 설정되었습니다."
else
    echo "일부 설정이 정상적으로 적용되지 않았습니다."
    echo "컨테이너를 재시작하고 실습환경 설정 스크립트를 다시 실행해주세요."
fi
echo "---------------------------------------------------"
echo
