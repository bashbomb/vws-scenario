# 시나리오 1-1 – 로그파일 실종사건 실습환경

이 디렉터리는 시나리오 1-1 실습을 위한 환경설정 파일과 스크립트를 포함하고 있습니다.  
강의 내용에 따라, 컨테이너 `cent1`에 접속한 상태에서 스크립트를 실행하여 실습환경을 구성합니다.

---

## 파일 구성

| 파일명            | 설명 |
|-------------------|------|
| `0.set_scenario1_env.sh`  | 실습에 필요한 로그 및 백업 스크립트를 자동으로 구성하는 스크립트 |
| `1.check_env.sh`    | 실습환경이 제대로 구성되었는지 확인하는 스크립트 |
| `backup.sh`       | 로그/웹소스/설정파일을 백업하는 스크립트 |

---

## 사용 방법

### 1. 실습 시나리오 파일 클론

컨테이너 `cent1`에 접속한 뒤, 아래와 같이 리포지터리를 클론합니다:

```bash
docker exec -it cent1 bash
cd /root
git clone https://github.com/bashbomb/vws-scenario.git
cd vws-scenario/1
```

---

### 2. 실습환경 구성

```bash
./0.set_scenario1_env.sh
```

- 로그 생성, 백업 스크립트 배치, cron 설정까지 자동으로 구성됩니다.

---

### 3. 환경 구성 점검

```bash
./1.check_env.sh
```

- `실습 환경이 정상적으로 설정되었습니다.` → 시나리오 진행 가능
- `설정에 문제가 있습니다.` → 아래의 방법으로 컨테이너를 재시작하고 재시도

---

### 컨테이너 재시작 방법

> 현재 `cent1` 컨테이너 안에 있는 상태라면, 아래 명령어를 실행하기 전에 먼저 컨테이너에서 **exit** 명령어로 나와야 합니다.

```bash
docker-compose restart cent1
```

재시작 후 다시 컨테이너에 접속한 뒤, 실습 디렉터리로 이동하여 환경 설정 스크립트를 다시 실행하세요:

```bash
docker exec -it cent1 bash
cd /root/vws-scenario/1
./0.set_scenario1_env.sh
```

---

실습 중 문제가 발생했다면 아래의 방법으로 해결해보세요:

- **실습용 환경설정 관련 문제는 강의 게시판을 통해 강사에게 질문하시는 것을 추천합니다.**
  실습 환경의 상태를 AI에게 모두 정확히 전달하기 어렵고, AI의 답변이 실제 문제 해결과 다를 수 있습니다.
- **AI에게 질문**하여 스스로 해결을 시도해볼 수 있습니다.
  실제 문제를 해결하기까지 시간이 걸릴 수 있지만 AI에게 질문하는 연습이 될 수 있습니다. 

---

# 라이선스

본 프로젝트는 CC BY-NC 4.0 라이선스에 따라 제공되며, 비영리 용도로 자유롭게 사용 가능합니다.
자세한 내용은 [LICENSE](../LICENSE) 파일을 확인해주세요.

