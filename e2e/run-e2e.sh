#!/usr/bin/env bash
# RealWorld(Conduit) 공식 API E2E 안전망 실행 스크립트.
# 마이그레이션 결과와 재구현 결과 모두, 동일한 공식 컬렉션 기준으로 레거시 baseline 통과 프로파일
# (현재 388 assertion)을 회귀 없이 통과해야 동등성이 인정된다. 문서화된 68개 갭 해소는 가점.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_URL="${1:-http://localhost:8080}"
APIURL="${BASE_URL%/}/api"

# 컬렉션의 Register/Login 요청은 {{USERNAME}}/{{EMAIL}}/{{PASSWORD}}를 외부 global-var로 요구한다
# (RealWorld 공식 run-api-tests.sh와 동일한 방식으로 매 실행마다 유니크한 계정을 생성).
USERNAME="${USERNAME:-u$(date +%s)}"
EMAIL="${EMAIL:-${USERNAME}@mail.com}"
PASSWORD="${PASSWORD:-password}"

echo "[run-e2e] target APIURL=${APIURL}"

npx --yes newman run "${SCRIPT_DIR}/conduit.postman_collection.json" \
  --global-var "APIURL=${APIURL}" \
  --global-var "USERNAME=${USERNAME}" \
  --global-var "EMAIL=${EMAIL}" \
  --global-var "PASSWORD=${PASSWORD}" \
  --delay-request 200
