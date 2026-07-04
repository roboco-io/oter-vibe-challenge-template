# NCR/NCS 리소스가 확정되어 실제 블록으로 채워지기 전까지는 값으로 참조할
# 리소스가 없으므로, 아래는 자리표시 주석입니다. ncr.tf/ncs.tf를 채운 뒤
# 대응하는 output의 주석을 해제하고 리소스 참조로 값을 채우세요.

# output "registry_uri" {
#   description = "NCR 컨테이너 이미지 push/pull에 사용할 레지스트리 URI"
#   value       = nhncloud_container_registry.this.<uri 속성명>
# }

# output "service_endpoint" {
#   description = "NCS(또는 확정된 서비스)의 외부 접근 엔드포인트"
#   value       = nhncloud_XXX_service.this.<endpoint 속성명>
# }
