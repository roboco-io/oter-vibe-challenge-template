# oter Vibe Coding 챌린지 — 템플릿 저장소

이 저장소는 "레거시 앱(app-legacy) → 마이그레이션/재구현 → 인프라 코드화 → CI/CD"
흐름의 채용 과제 템플릿이다. 과제 배경·평가 기준의 전체 설명은
[roboco-io/oter-vibe-challenge](https://github.com/roboco-io/oter-vibe-challenge)
저장소를 함께 참고한다.

> **Claude Code 필수.** 이 과제는 Claude Code 사용을 전제로 설계됐다(회고 자동화,
> 토큰 효율 평가 등 일부 항목은 Claude Code 세션 로그가 있어야 측정된다). 다른
> AI 도구를 병행해도 되지만, 규칙은 `CLAUDE.md`(Claude Code용)와
> `AGENTS.md`(타 도구용)를 모두 확인한다.

## 퀵스타트

```bash
# 1) Retrobot pre-push 훅 설치 (최초 1회)
bash scripts/install-hooks.sh

# 2) 레거시 앱 기동
cd app-legacy && docker compose up -d --build
# 완전 초기화(seed 중복 방지)가 필요하면: docker compose down -v
cd ..

# 3) E2E 안전망 실행 (저장소 루트에서)
bash e2e/run-e2e.sh http://localhost:8080

# 4) 이후 진행 순서
#   - 재구현 앱 작성 (레거시와 다른 언어/프레임워크 가능)
#     -> 검증: bash e2e/run-e2e.sh http://localhost:<재구현 포트>
#   - ADR 작성 (docs/ADR/ADR.template.md 복사, 최소 2건: 재구현 스택, NCS/NCR 프로비저닝)
#   - Terraform으로 지원 인프라 코드화 + NCS/NCR 프로비저닝 접근을 ADR로 정당화 (infra/)
#   - GitHub Actions 파이프라인 완성 (.github/workflows/deploy.yml의 TODO 채우기)
```

각 단계의 세부 규칙은 `CLAUDE.md`(또는 `AGENTS.md`)에, 앱 기동/E2E 세부는
`e2e/README.md`에, 인프라 세부는 `infra/README.md`에 있다.

## Must / Stretch 요약

| 구분 | 내용 |
|---|---|
| Must | 레거시 앱 기동 확인, 재구현(다른 스택), E2E baseline 프로파일(388/456) 유지, ADR 2건 이상, 데일리 push, Terraform으로 지원 인프라 코드화 |
| Stretch | E2E의 문서화된 68개 갭 해소(타임스탬프 형식·에러 바디 계약·상태 코드 등), NCS/NCR까지 포함한 배포 자동화 완성, GitHub Actions 전체 그린 |

정확한 배점·세부 채점 기준은 설명 저장소
([roboco-io/oter-vibe-challenge](https://github.com/roboco-io/oter-vibe-challenge))의
평가 기준 문서를 따른다. 이 템플릿 저장소의 문서(`CLAUDE.md`, `e2e/README.md`,
`infra/README.md` 등)는 그 기준을 이 코드베이스의 현실에 맞게 구체화한 것이다.

## 평가가 보는 것 (요약)

- **동등성**: "완전 그린"이 아니라 **baseline 프로파일 유지·개선**. 레거시는 v2 E2E
  컬렉션 456개 assertion 중 388개만 통과하며(68개 실패는 `e2e/README.md`에 원인별로
  문서화됨), 재구현은 이 프로파일 대비 회귀하지 않으면 동등성 기준을 만족한다.
- **인프라**: Terraform provider(`nhn-cloud/nhncloud`)에는 NCR/NCS 네이티브 리소스가
  없다. 지원 인프라(네트워크 등)는 Terraform으로 코드화하고, NCS/NCR 자체의
  프로비저닝 방식(콘솔/CLI/API/local-exec)은 ADR로 선택 근거를 남긴다.
- **성장 궤적**: 최종 결과물만이 아니라 일주일간의 변화를 본다. `docs/PROGRESS.md`
  인덱스와 `retros/`의 Retrobot 자동 회고(날짜별 KPT)가 1순위 사료다.
- **AI 활용의 투명성**: AI를 얼마나, 어떻게 썼는지가 커밋 메시지·ADR·회고에 드러나는
  것 자체가 평가 대상이다.

## 디렉토리 구조

```
app-legacy/   레거시 slim-php RealWorld 구현 (마이그레이션 대상, 소스 직접 수정 안 함)
e2e/          RealWorld v2 공식 Postman 컬렉션 기반 E2E 안전망 (Newman)
infra/        NHN Cloud Terraform 스켈레톤 (지원 인프라 + NCS/NCR 스텁)
.github/      GitHub Actions 배포 파이프라인 골격 (test -> build -> deploy)
retrobot/     push 시점 자동 KPT 회고 시스템
retros/       Retrobot이 생성한 회고 파일들
docs/ADR/     의사결정 기록 (ADR)
docs/PROGRESS.md  데일리 진행 인덱스
scripts/install-hooks.sh  Retrobot 훅 설치 스크립트
```

## 시크릿 취급

이 저장소 어디에도 자격증명(NHN Cloud 계정, JWT 시크릿 등)을 하드코딩하지 않는다.
로컬 값은 `.env`(gitignore 대상) 또는 환경변수로만 주입한다. 자세한 규칙은
`CLAUDE.md`를 참고한다.
