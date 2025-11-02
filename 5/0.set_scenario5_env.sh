#!/bin/bash
# 0.set_scenario5_env.sh
# 시나리오5 - 착한 사람에게만 보이는 백업파일!?

# 1. 백업 스크립트 복사
cp -f ./backup.sh /root/backup.sh
chmod +x /root/backup.sh

# 2. 백업 디렉터리 준비
mkdir -p /mnt/backup

# 3. 크론탭 등록
(crontab -l 2>/dev/null; echo "0 0 * * * /root/backup.sh") | crontab -

# 4. NFS 서버 설정
ssh cent3 "[ \$(pgrep rpc.mountd) ] && kill -9 \$(pgrep rpc.mountd)" > /dev/null 2>&1

# 5. 백업 설정
DATE=$(/bin/date +%F)

mkdir -p /mnt/backup/logs/${DATE}
mkdir -p /mnt/backup/web_src/${DATE}
mkdir -p /mnt/backup/config/${DATE}

echo "dummy log content" > /mnt/backup/logs/${DATE}/messages.log
echo "dummy web src" > /mnt/backup/web_src/${DATE}/html.tar.gz
echo "dummy config" > /mnt/backup/config/${DATE}/nginx_config.tar.gz

cat <<EOF > /var/log/backup_${DATE}.log
[$(date '+%Y-%m-%d %T')] 백업 스크립트 시작
[$(date '+%Y-%m-%d %T')] 웹 소스 백업 완료
[$(date '+%Y-%m-%d %T')] 설정 파일 백업 완료
[$(date '+%Y-%m-%d %T')] 로그 파일 백업 완료
[$(date '+%Y-%m-%d %T')] /mnt 마운트 해제 완료
[$(date '+%Y-%m-%d %T')] 백업 스크립트 종료
EOF

echo ""
echo "================================================================"
echo " 환경 설정 완료!"
echo " 환경 설정이 끝나면 1.check_env.sh로 점검하세요."
echo "================================================================"

