# infra — NHN Cloud Terraform 스켈레톤

이 디렉토리는 지원자가 채워 NCR(NHN Container Registry)/NCS(컨테이너 실행
서비스)를 코드화하기 위한 Terraform 뼈대입니다. **이 상태로는 apply할 수
없습니다** — 인증값과 핵심 리소스 타입이 아직 확정되지 않은 스텁이기
때문입니다.

## 고정 스택

- IaC 도구: Terraform (`>= 1.5`)
- Provider: [`nhn-cloud/nhncloud`](https://registry.terraform.io/providers/nhn-cloud/nhncloud/latest) (`~> 1.0`)

## 파일 구성

| 파일 | 내용 |
|---|---|
| `main.tf` | `required_providers` 선언 + provider 블록(인증은 변수 참조) |
| `variables.tf` | region/인증/이미지 태그 등 변수 선언 (값 없음) |
| `ncr.tf` | Container Registry 리소스 자리 — **주석 스텁** |
| `ncs.tf` | 컨테이너 워크로드 실행 서비스 리소스 자리 — **주석 스텁** |
| `outputs.tf` | 레지스트리 URI/서비스 엔드포인트 출력 자리 — **주석 스텁** |

## 지원자 TODO (필수)

1. **인증/리전 채우기**: `variables.tf`의 변수는 값이 비어 있습니다.
   `TF_VAR_username`, `TF_VAR_password` 등 환경변수 또는 커밋되지 않는
   `*.auto.tfvars` 파일로 실제 값을 주입하세요. **이 저장소 어떤 파일에도
   자격증명을 하드코딩하지 마세요.**
2. **NCR/NCS 리소스 확정**: `ncr.tf`, `ncs.tf`를 조사한 결과(2026-07 기준,
   provider v1.0.9) 이 provider에는 Container Registry 리소스도, "NCS"라는
   이름의 리소스도 존재하지 않았습니다. 존재가 확인된 것은 Kubernetes 계열
   (`nhncloud_kubernetes_cluster_v1`, `nhncloud_kubernetes_nodegroup_v1`)뿐입니다.
   apply하기 전에 반드시
   [provider 문서](https://registry.terraform.io/providers/nhn-cloud/nhncloud/latest/docs)에서
   본인이 쓸 버전 기준으로 실제 리소스 타입(또는 CLI/API 대체 방식)을
   확정하고, 그 결과로 `ncr.tf`/`ncs.tf`/`outputs.tf`의 주석 스텁을 실제
   리소스 블록으로 교체하세요.
3. **예산 주의**: apply 전 과제 예산(5만원)을 확인하세요. 최소 사양
   인스턴스/스토리지로 구성하고, 작업이 끝나면 즉시
   `terraform destroy`로 리소스를 정리해 과금이 누적되지 않게 하세요.

## 금지 사항

- 자격증명, API 키, 비밀번호 등 시크릿을 이 디렉토리(혹은 저장소 어디에도)
  하드코딩하거나 커밋하지 마세요.
- `terraform.tfstate*`, `.terraform/` 디렉토리는 저장소 루트 `.gitignore`에
  이미 등록되어 있습니다(`*.tfstate*`, `.terraform/`). 별도 tfvars 파일에
  실제 값을 넣었다면 그 파일도 커밋하지 말고 `.gitignore`에 추가하세요.

## 검증 방법

```sh
cd infra
terraform fmt -check     # 포맷 검사 (실패 시 `terraform fmt`로 정리)
terraform init -backend=false   # provider 다운로드 (네트워크 필요)
terraform validate        # 문법/스키마 검증
```

네트워크가 막혀 `terraform init`이 provider를 내려받지 못하면
`terraform validate`도 함께 실패합니다. 이 경우 `terraform fmt -check`
통과만으로 HCL 문법 오류가 없음을 확인할 수 있습니다.
