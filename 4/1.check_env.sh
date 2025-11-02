#!/bin/bash

# 1.check_env.sh
# VWS 시나리오 1-4 실습 환경 확인 스크립트

NGINX_CONF_CHECK=false
LOG_DIR_CHECK=false
ACCESS_LOG_CHECK=false
ERROR_LOG_CHECK=false
ACCESS_LOG_SIZE_CHECK=false

# 1. nginx 설정 확인
if grep -q "log_format main" /etc/nginx/nginx.conf; then
    NGINX_CONF_CHECK=true
fi

# 2. 로그 디렉터리 확인
if [ -d /usr/local/nginx/logs ]; then
    LOG_DIR_CHECK=true
fi

# 3. access 로그 파일 존재 확인
if [ -f /usr/local/nginx/logs/VWS.access.log ]; then
    ACCESS_LOG_CHECK=true
fi

# 4. error 로그 파일 존재 확인
if [ -f /usr/local/nginx/logs/VWS.error.log ]; then
    ERROR_LOG_CHECK=true
fi

# 5. access 로그 파일 크기 확인 (1GB = 1073741824 bytes)
if [ -f /usr/local/nginx/logs/VWS.access.log ]; then
    FILE_SIZE=$(stat -c%s /usr/local/nginx/logs/VWS.access.log)
    if [ "${FILE_SIZE}" -ge 1073741824 ]; then
        ACCESS_LOG_SIZE_CHECK=true
    fi
fi

# 최종 결과
if ${NGINX_CONF_CHECK} && ${LOG_DIR_CHECK} && ${ACCESS_LOG_CHECK} && ${ERROR_LOG_CHECK} && ${ACCESS_LOG_SIZE_CHECK}; then
    echo "환경 설정이 정상적으로 완료되었습니다."
else
    echo "일부 설정이 정상적으로 적용되지 않았습니다."
    echo "컨테이너를 재시작하고 실습환경 설정 스크립트를 다시 실행해주세요."
fi
