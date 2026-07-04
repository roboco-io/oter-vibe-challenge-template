# AGENTS.md — 타 AI 도구(Codex/Gemini 등)용 규칙

이 파일은 Claude Code 이외의 에이전트(Codex CLI, Gemini CLI 등)를 이 저장소에서
쓰는 지원자를 위한 것이다. 규칙 내용은 `CLAUDE.md`와 **완전히 동일**하며, 아래는
그 요약과 도구별 차이만 다룬다. 규칙의 원문·근거는 `CLAUDE.md`를 참고하라.

## 공통 규칙 (요약)

1. 시크릿·개인정보는 `.env`(gitignore 대상)/환경변수로만 주입한다. 어떤 파일에도
   하드코딩·커밋하지 않는다.
2. E2E(`e2e/run-e2e.sh`) 판정 기준은 **"완전 그린"이 아니라 baseline 프로파일
   (388/456 assertion 통과) 유지·개선**이다. 재구현이 이 프로파일 대비 회귀하면
   안 되고, 문서화된 68개 갭(`e2e/README.md`) 해소는 가점이다.
3. ADR 최소 2건: (a) 재구현 스택 선택, (b) NCS/NCR 프로비저닝 접근(Terraform provider에
   NCR/NCS 네이티브 리소스가 없으므로 콘솔/CLI/API/local-exec 중 선택해 정당화).
   Terraform으로 NCS/NCR을 네이티브 관리하는 방향은 불가능하므로 시도하지 않는다.
4. 매일 최소 1회 커밋을 push한다.
5. 파괴적 작업 전에는 의도를 재확인한다.
6. AI 사용 사실과 협업 방식(신뢰한 부분/직접 검증한 부분)을 커밋 메시지·ADR에 드러낸다.
7. 앱 재기동은 `cd app-legacy && docker compose up -d --build`, 완전 초기화는
   `docker compose down -v`(포트 8080, `/api` prefix).

## Claude Code 전제 기능에 대한 예외

이 저장소의 두 기능은 **Claude Code(`~/.claude` 세션 로그) 사용을 전제**로 설계되어
있으며, 다른 에이전트로는 동일하게 동작하지 않는다.

- **Retrobot**(`retrobot/`, `.githooks/pre-push`): push 시점에 회고를 생성할 때
  `claude` CLI를 우선 사용한다(`retrobot/SKILL.md`를 프롬프트로 헤드리스 실행).
  `claude`가 없으면 `codex exec` 또는 `gemini -p`로 폴백하지만, 이 경우 회고는
  Claude Code 세션 로그를 참조하지 못하고 git 로그만으로 작성되어 내용이 상대적으로
  빈약해질 수 있다.
- **토큰 효율 평가(tokenhabit)**: `uvx tokenhabit --days 1 --lang ko`는
  `~/.claude/projects/*.jsonl` 세션 로그를 분석 대상으로 삼는다. **Codex/Gemini만
  사용한 경우 이 로그 자체가 생성되지 않으므로 토큰 효율 지표를 측정할 수 없다.**
  즉 토큰 효율 평가 항목은 사실상 Claude Code 사용자에게만 적용된다. 다른 도구를
  주력으로 쓰더라도, 이 지표를 평가받으려면 최소한 일부 작업을 Claude Code로도
  수행해 세션 로그를 남겨야 한다.

두 기능 모두 실패해도 push 자체를 막지는 않는다(안전 원칙, `retrobot/README.md` 참고).
다만 회고·토큰효율 데이터가 비면 평가 근거(특히 "성장 궤적")가 그만큼 줄어든다.
