# 모든 변수는 값을 선언하지 않습니다. 실제 값은 아래 방법 중 하나로만 주입하세요.
#   - 환경변수: TF_VAR_<name> (예: TF_VAR_username, TF_VAR_password)
#   - 커밋되지 않는 *.auto.tfvars 파일 (repo .gitignore에 tfvars 패턴 추가 필요 시 함께 추가)
# 자격증명을 이 저장소의 어떤 파일에도 하드코딩하지 마세요.

variable "region" {
  description = "리소스를 생성할 NHN Cloud 리전 (예: KR1, KR2, JP1)"
  type        = string
}

variable "auth_url" {
  description = "NHN Cloud Identity 서비스 인증 URL (콘솔 > Compute > Instance > Management > Set API Endpoint 에서 확인)"
  type        = string
}

variable "tenant_id" {
  description = "NHN Cloud Tenant ID (콘솔 > Compute > Instance > Management > Set API Endpoint 에서 확인)"
  type        = string
}

variable "tenant_name" {
  description = "NHN Cloud Tenant 이름. provider 인자로는 사용되지 않으며 리소스 네이밍/태깅 참고용"
  type        = string
  default     = null
}

variable "username" {
  description = "NHN Cloud API 사용자 ID"
  type        = string
}

variable "password" {
  description = "NHN Cloud API Password (콘솔에서 발급한 API Password, 로그인 비밀번호 아님)"
  type        = string
  sensitive   = true
}

variable "image_tag" {
  description = "NCR에 푸시/배포할 컨테이너 이미지 태그 (예: v0.1.0). 지원자가 CI/CD 파이프라인과 맞춰 채운다"
  type        = string
  default     = "latest"
}

variable "service_name" {
  description = "NCS(또는 확정된 컨테이너 실행 서비스)에 배포할 워크로드/서비스 식별 이름"
  type        = string
  default     = null
}
