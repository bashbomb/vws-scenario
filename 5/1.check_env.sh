#!/bin/bash
# 1.check_env.sh
# 시나리오5 환경 점검 스크립트

DATE=$(/bin/date +%F)
ERROR=0

# 1. /mnt/backup 디렉터리 확인
[ -d /mnt/backup ] || ERROR=1

# 2. /mnt/backup 하위 디렉터리 확인
for dir in logs web_src config; do
  [ -d /mnt/backup/${dir}/${DATE} ] || ERROR=1
done

# 3. 백업 로그 파일 확인
[ -f /var/log/backup_${DATE}.log ] || ERROR=1

# 4. cent3 서버 rpc.mountd 프로세스 확인
ssh cent3 "ps -ef | grep rpc.mountd | grep defunct" >/dev/null 2>&1
if ! ssh cent3 "ps -ef | grep rpc.mountd | grep defunct" >/dev/null 2>&1; then
  ERROR=1
fi

# 결과 출력
if [ ${ERROR} -eq 0 ]; then
  echo "환경 설정이 정상적으로 완료되었습니다."
else
  echo ""
  echo "일부 설정이 정상적으로 적용되지 않았습니다."
  echo "컨테이너를 재시작하고 실습환경 설정 스크립트를 다시 실행해주세요."
fi

