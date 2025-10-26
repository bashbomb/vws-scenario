#!/bin/bash

# VWS 시나리오 환경 점검 스크립트

# 점검 결과 초기화
CHECK_RESULT="OK"

# 1. DB 유저 확인
USER_EXIST=$(mysql -uroot mysql -Nse "SELECT COUNT(*) FROM user WHERE user='vwswebdb' AND host='localhost';" 2>/dev/null)

if [ "${USER_EXIST}" != "1" ]; then
    CHECK_RESULT="NG"
fi

# 최종 결과 출력
if [ "${CHECK_RESULT}" = "OK" ]; then
    echo "실습 환경이 정상적으로 준비되었습니다!"
else
    echo "실습 환경에 문제가 있습니다."
    echo "컨테이너를 재시작하고 다시 실습 환경을 셋업해 주세요."
fi
