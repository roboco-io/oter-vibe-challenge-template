# ADR-NNNN: <결정 제목을 한 문장으로>

## 상태

<Proposed | Accepted | Superseded by ADR-XXXX | Deprecated> — YYYY-MM-DD

## 맥락 (Context)

- 어떤 문제/제약 상황에서 이 결정이 필요했는가?
- 관련된 사실관계(예: provider 조사 결과, E2E 실행 결과 등)를 근거와 함께 적는다.
  "확인했다"가 아니라 무엇을 어떻게 확인했는지 남긴다(커맨드, 문서 링크, 실측값).

## 결정 (Decision)

- 무엇을 하기로 했는가? 한 문단으로 명확하게.

## 대안 (Alternatives Considered)

| 대안 | 장점 | 단점 | 기각 사유 |
|---|---|---|---|
| A | | | |
| B | | | |

## 결과 (Consequences)

- 이 결정으로 무엇이 좋아지고, 무엇을 감수해야 하는가?
- 후속 작업/제약이 생기면 명시한다(예: "이 결정으로 X는 더 이상 불가능하다").

---

## 이 저장소에서 최소로 요구되는 ADR 2건

1. **재구현 스택 선택** — 레거시(app-legacy, slim-php)를 어떤 언어/프레임워크로
   재구현할지, 왜 그것을 택했는지(팀 숙련도, 생태계, RealWorld 스펙과의 궁합 등).
   E2E 판정 기준이 "baseline 프로파일(388/456) 유지·개선"임을 전제로, 재구현에서
   `e2e/README.md`의 알려진 68개 갭 중 어디까지 고칠지도 이 ADR 또는 별도 ADR에서
   범위를 정한다.
2. **NCS/NCR 프로비저닝 접근** — `nhn-cloud/nhncloud` Terraform provider에는
   NCR·NCS 네이티브 리소스가 없다(`infra/README.md`, `infra/ncr.tf`, `infra/ncs.tf`
   참고). 콘솔 수동/CLI/REST API/`local-exec` 중 어떤 방식으로 NCS·NCR을 프로비저닝할지
   선택하고, Terraform은 그중 어디까지(지원 인프라만 vs `null_resource` 포함)
   책임지는지를 근거와 함께 정당화한다.

파일명 규칙: `docs/ADR/0001-<slug>.md`, `docs/ADR/0002-<slug>.md` ... 번호는 3건째부터
이어서 자유롭게 추가한다.
