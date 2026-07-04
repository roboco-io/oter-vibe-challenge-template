# CLAUDE.md — oter Vibe Coding 챌린지 규칙

이 파일은 Claude Code가 이 저장소에서 작업할 때 반드시 지켜야 하는 규칙이다.
지원자(사람)도 동일한 규칙을 따른다. 다른 AI 도구(Codex/Gemini 등)를 쓴다면
`AGENTS.md`를 참고하라 — 내용은 동일하되 도구별 차이만 다르다.

## 이 저장소의 구조

| 경로 | 성격 |
|---|---|
| `app-legacy/` | 레거시 slim-php 기반 RealWorld(Conduit) 구현. **마이그레이션 대상**이며, 이 디렉토리 자체의 앱 소스는 과제 중 직접 수정하지 않는다(버그가 있어도 "레거시의 한계"로 문서화한다). |
| (지원자가 만들 새 디렉토리, 예: `app-new/`) | **재구현 대상**. 레거시와 다른 언어/프레임워크로 새로 작성해도 된다. |
| `e2e/` | RealWorld v2 공식 Postman 컬렉션 기반 안전망(Newman). 레거시·재구현 양쪽에 동일 기준으로 실행. |
| `infra/` | NHN Cloud Terraform 스켈레톤(지원 인프라용). NCR/NCS 자체는 provider 네이티브 리소스가 없다(아래 참고). |
| `.github/workflows/deploy.yml` | test → build(NCR push) → deploy(NCS 갱신) 파이프라인 골격. NCR/NCS 스텝은 TODO 상태. |
| `retrobot/`, `retros/`, `.githooks/pre-push` | push 시점 자동 KPT 회고 시스템. |
| `docs/ADR/`, `docs/PROGRESS.md` | 의사결정 기록과 진행 인덱스. |

## 절대 규칙

1. **시크릿·개인정보를 커밋하지 않는다.** API 키, NHN Cloud 자격증명, JWT 시크릿(운영용) 등은
   어떤 파일에도 하드코딩하지 말고 `.env`(gitignore 대상) 또는 환경변수(`TF_VAR_*` 등)로만
   주입한다. `.env.example`류의 템플릿 파일에는 값이 아니라 키 이름만 남긴다.
2. **E2E 안전망은 "baseline 프로파일 유지·개선"이 기준이다.** 이 slim 세대 레거시 앱은
   최신 v2 컬렉션을 완전히 통과하지 못한다(456 assertion 중 388 통과, 68 실패 —
   원인은 `e2e/README.md`에 항목별로 문서화되어 있다). 따라서 "E2E가 완전히 그린이어야
   한다"가 아니라 **"현재 통과 중인 388개 프로파일이 바닥선이며, 재구현이 이 프로파일
   대비 회귀하면 안 된다"**가 기준이다. 문서화된 68개 갭(타임스탬프 형식, 에러 바디 계약,
   상태 코드, 검증 메시지 등)을 재구현에서 해소하면 가점 대상이지 필수 통과 조건은 아니다.
   재구현 검증은 `bash e2e/run-e2e.sh http://localhost:<재구현 포트>`로 그대로 재사용한다.
3. **ADR(Architecture Decision Record)을 남긴다.** 최소 2건 필수 — (a) 재구현 스택 선택,
   (b) NCS/NCR 프로비저닝 접근 방식. 틀은 `docs/ADR/ADR.template.md`를 복사해 쓴다.
4. **데일리 push.** 매일 최소 1회 커밋을 push한다. `.githooks/pre-push` 훅(Retrobot)이
   24시간 이내 회고가 없으면 자동으로 KPT 회고를 생성해 커밋하므로, 이를 방해하거나
   우회하지 않는다. 설치: `bash scripts/install-hooks.sh`.
5. **안전 프롬프트.** 파괴적 작업(`terraform destroy` 제외 — 이건 오히려 과제 종료 시
   권장됨, `rm -rf`, force push, 시크릿이 포함될 수 있는 로그 덤프 등)은 실행 전 의도를
   한 번 더 확인한다.
6. **AI 사용을 드러내라.** 이 과제는 AI 도구(Claude Code) 사용을 전제로 설계됐다. AI와
   어떻게 협업했는지, 어디를 신뢰하고 어디를 직접 검증했는지를 커밋 메시지·ADR·회고에
   구체적으로 남긴다. 감추거나 "직접 짠 것처럼" 포장하지 않는다.

## Terraform / NCS·NCR 관련 현실

NHN Cloud Terraform provider(`nhn-cloud/nhncloud` v1.0.9 기준)에는 **NCR(Container
Registry)·NCS라는 이름의 네이티브 리소스가 없다.** provider가 지원하는 것은 compute,
blockstorage, keymanager, kubernetes(NKS: cluster/nodegroup), lb, nas, networking뿐이다.

따라서 M4(인프라)는 다음 두 가지로 구성된다.

- **Terraform으로 코드화**: 네트워크, 로드밸런서 등 provider가 실제로 지원하는 지원
  인프라(supporting infrastructure)는 Terraform으로 관리한다.
- **NCS/NCR 프로비저닝 접근은 지원자가 선택하고 ADR로 정당화**: 콘솔 수동 생성, NHN
  Cloud CLI, NHN Cloud REST API 직접 호출, `null_resource` + `local-exec` 중 하나를
  택하고 왜 그 방식을 골랐는지(provider 갭, 대안 비교 포함)를 ADR에 남긴다.
  **"Terraform으로 NCS/NCR을 네이티브 관리한다"는 방향은 이 provider로는 불가능하므로
  선택지에서 제외한다.**

자세한 조사 근거는 `infra/README.md`, `infra/ncr.tf`, `infra/ncs.tf`의 주석을 참고하라.

## 앱 재기동 / 초기화

```bash
cd app-legacy && docker compose up -d --build   # 기동
cd app-legacy && docker compose down -v         # 완전 초기화 (seed 중복 방지, 볼륨까지 삭제)
```

포트는 `8080`, API prefix는 `/api`이다(`APIURL=http://localhost:8080/api`). 재구현 앱을
검증할 때는 `bash e2e/run-e2e.sh http://localhost:<재구현 포트>`로 base URL만 바꾼다.

## pre-push 훅이 `--dangerously-skip-permissions`를 쓰는 이유

`.githooks/pre-push`는 `claude -p "$(cat retrobot/SKILL.md)" --dangerously-skip-permissions`
형태로 Claude Code를 헤드리스 실행한다. push 훅은 사람이 승인 프롬프트에 응답할 수 없는
비대화형 컨텍스트이므로, 이 플래그 없이는 권한 확인 단계에서 그대로 멈춰 push 자체가
막힌다. 훅은 실패해도 push를 절대 막지 않도록 설계돼 있으니(`retrobot/README.md` 참고)
이 플래그는 편의를 위한 예외이지 일반 작업에서 습관적으로 쓸 플래그가 아니다.
