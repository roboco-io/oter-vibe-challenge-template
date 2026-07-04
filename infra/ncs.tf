# =============================================================================
# NCS (컨테이너 워크로드 실행 서비스) — 리소스 스텁
#
# 조사 결과(2026-07 기준, nhn-cloud/nhncloud provider v1.0.9 docs 전체 확인):
# provider에 "NCS" 명칭과 정확히 일치하는 리소스는 없습니다. 컨테이너
# 오케스트레이션에 가장 가까운 리소스는 Kubernetes 계열
# (nhncloud_kubernetes_cluster_v1, nhncloud_kubernetes_nodegroup_v1)이지만,
# 이것이 이 과제에서 의도한 "NCS"와 동일 서비스인지는 확정되지 않았습니다.
#
# 지원자 TODO(필수 — 아래 중 하나로 확정 후 진행):
#   1. NHN Cloud 콘솔/문서에서 이 과제가 요구하는 실행 서비스가
#      Kubernetes Service(NKS)인지, 별도의 Container-as-a-Service(NCS)인지
#      확인하세요.
#   2. provider 문서(https://registry.terraform.io/providers/nhn-cloud/nhncloud/latest/docs)
#      에서 해당 서비스의 정확한 리소스 타입명을 확정하세요.
#   3. NKS(Kubernetes)로 확정되면 nhncloud_kubernetes_cluster_v1 +
#      nhncloud_kubernetes_nodegroup_v1로 클러스터를 구성하고, 컨테이너
#      워크로드 배포(이미지/포트/환경변수)는 Kubernetes 매니페스트
#      (kubernetes_deployment 등 별도 provider) 또는 Helm으로 다루는 편이
#      Terraform 리소스 매핑상 자연스럽습니다.
#   4. 리소스 타입이 확정되지 않은 provider 전용 NCS가 있다면, 존재하지
#      않는 이름을 지어내지 말고 위 문서를 근거로 실제 이름으로 교체하세요.
#
# 아래는 컨테이너 워크로드를 실행한다고 가정했을 때 채워야 할 항목의
# 자리표시 주석입니다. 실제 리소스 블록으로 교체 전까지는 주석 상태로 둡니다.
#
# resource "nhncloud_XXX_service" "this" {
#   name  = var.service_name
#   image = "<NCR 레지스트리 URI>/<repo>:${var.image_tag}"   # ncr.tf의 레지스트리 출력 참조
#   port  = 8080                                              # 앱이 리스닝하는 포트로 교체
#
#   env {
#     name  = "EXAMPLE_ENV"
#     value = "example-value"
#   }
# }
# =============================================================================
