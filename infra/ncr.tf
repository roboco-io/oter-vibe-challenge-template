# =============================================================================
# NCR (NHN Container Registry) — 리소스 스텁
#
# 조사 결과(2026-07 기준, nhn-cloud/nhncloud provider v1.0.9 docs/resources,
# docs/data-sources 전체 목록 확인): 이 provider에는 Container Registry 관련
# 리소스/데이터소스(nhncloud_container_registry_* 등)가 존재하지 않습니다.
# provider가 공식 지원하는 리소스는 compute, blockstorage, keymanager,
# kubernetes(cluster/nodegroup), lb, nas, networking 계열뿐입니다.
#
# 지원자 TODO:
#   1. https://registry.terraform.io/providers/nhn-cloud/nhncloud/latest/docs
#      에서 본인이 사용할 provider 버전 기준으로 NCR 리소스 지원 여부를 재확인하세요.
#      (버전이 올라가며 리소스가 추가됐을 수 있습니다.)
#   2. Terraform 리소스가 없다면 대안을 선택하세요:
#      - `null_resource` + `local-exec`/`toolbox_cmd`로 NHN Cloud CLI(ntctl)
#        또는 REST API(Docker Registry HTTP API v2 호환)를 호출
#      - 또는 레지스트리 자체는 콘솔/CLI로 사전 생성하고, Terraform은 이미지
#        push 대상 URI만 변수/output으로 참조
#   3. 어떤 방식을 택하든 자격증명은 변수로만 주입하고 이 파일에 값을 적지 마세요.
#
# 아래는 리소스가 실제로 존재한다고 가정했을 때의 형태 예시이며, 존재하지
# 않는 리소스 타입이므로 주석 처리된 상태로만 남겨둡니다. 지원자가 provider
# 문서로 확정한 뒤 실제 리소스 블록으로 교체하세요.
#
# resource "nhncloud_container_registry" "this" {
#   name   = "${var.tenant_name}-registry"
#   region = var.region
# }
# =============================================================================
