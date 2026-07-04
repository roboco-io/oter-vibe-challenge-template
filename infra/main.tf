# =============================================================================
# 지원자 TODO
# 1. 인증 정보(변수)와 리전을 본인 NHN Cloud 계정에 맞게 채우세요. 값은
#    이 저장소가 아니라 환경변수 또는 별도 *.auto.tfvars(gitignore 대상)로 주입합니다.
# 2. `terraform apply` 실행 전, 반드시 예산(과제 한도 5만원)을 확인하고
#    소형 인스턴스/최소 리소스로 구성한 뒤 작업 종료 시 `terraform destroy`로
#    즉시 정리하세요. 자격증명이나 tfstate는 절대 커밋하지 않습니다.
# 3. NCR/NCS 리소스 지원 여부는 provider 문서로 반드시 재확인하세요
#    (ncr.tf, ncs.tf의 안내 주석 참고).
# =============================================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    nhncloud = {
      source  = "nhn-cloud/nhncloud"
      version = "~> 1.0"
    }
  }
}

# 인증값은 변수로만 주입합니다(하드코딩 금지). 실제 값은 환경변수
# (예: TF_VAR_username, TF_VAR_password) 또는 커밋되지 않는 tfvars 파일로 전달하세요.
#
# provider 스키마(nhn-cloud/nhncloud v1.0.x, docs/index.md 기준) 필수 인자는
# user_name/tenant_id/password/auth_url/region 다섯 개입니다. var.tenant_name은
# provider 인자로 쓰이지 않으며 리소스 네이밍 등 참고용으로만 선언해 두었습니다.
provider "nhncloud" {
  user_name = var.username
  password  = var.password
  tenant_id = var.tenant_id
  auth_url  = var.auth_url
  region    = var.region
}
