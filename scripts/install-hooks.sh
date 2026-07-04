#!/usr/bin/env bash
# Retrobot pre-push 훅을 최초 1회 활성화한다.
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

chmod +x .githooks/pre-push
git config core.hooksPath .githooks

echo "설정 완료: core.hooksPath=.githooks"
echo "이제부터 git push 시 retros/ 에 24시간 이내 회고가 없으면 Retrobot이 자동으로 KPT 회고를 생성합니다."
echo "자세한 내용: retrobot/README.md"
