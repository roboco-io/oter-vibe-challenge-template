# Retrobot — Push 시점 자동 회고

## 왜 필요한가

이 과제는 **매일 커밋을 push**하는 것을 필수 요구사항으로 둡니다. 데일리 push를
지키지 않으면 다른 항목 점수와 무관하게 감점됩니다. 평가는 최종 결과물만이 아니라
**일주일간의 성장 궤적**을 봅니다. 그중에서도 Retrobot이 남기는 KPT
(Keep/Problem/Try) 회고는 **성장 평가의 1순위 사료**입니다 — 초반 회고와 후반
회고를 나란히 놓고 내용이 얼마나 구체화·심화됐는지를 확인합니다.

## 무엇을 하는가

`git push`를 실행하면 `.githooks/pre-push` 훅이 다음을 확인합니다.

- `retros/`에 24시간 이내에 생성된 회고가 있으면 그대로 push를 진행합니다.
- 없으면(또는 마지막 회고로부터 하루가 지났으면) `claude -p "$(cat retrobot/SKILL.md)"`를
  호출해 최근 Claude Code 세션 로그(`~/.claude/projects/*.jsonl`)와
  `uvx tokenhabit --days 1 --lang ko` 결과를 바탕으로 KPT 회고를 생성하고,
  `retros/YYYY-MM-DD-HHMM.md`로 저장한 뒤 `[Retrobot]` 태그가 붙은 커밋을 자동으로
  만듭니다(그 커밋 자체는 다음 push부터 원격에 반영됩니다).
- 방금 만든 커밋이 `[Retrobot]` 커밋이면(재귀 방지) 이번 트리거는 건너뜁니다.

## claude CLI가 없거나 회고 생성이 실패하면

**push는 절대 막히지 않습니다.** 경고 메시지만 출력하고 정상적으로 push가
진행됩니다. 다만 회고가 쌓이지 않으면 성장 평가 사료가 비게 되니, 가능하면 Claude
Code를 설치해 사용하세요.

## 설치 (최초 1회)

```bash
bash scripts/install-hooks.sh
```

`git config core.hooksPath .githooks`를 설정하고 훅에 실행 권한을 부여합니다.

## tokenhabit 설치

```bash
uvx tokenhabit --days 1 --lang ko   # uv가 설치되어 있으면 별도 설치 없이 바로 실행됩니다
```

## 원칙: AI를 숨기지 말고 드러내라

이 과제는 AI 도구(Claude Code) 사용을 전제로 설계되었습니다. AI를 썼다는 사실을
감추거나 부끄러워할 필요가 없습니다. 오히려 **AI와 어떻게 협업했는지, 어디를
신뢰하고 어디를 직접 검증했는지**가 회고와 ADR에 드러나는 것이 좋은 평가로
이어집니다. Retrobot 회고, tokenhabit 리포트, 커밋 메시지 모두 "AI를 얼마나 잘
활용했는가"를 보여주는 증거로 취급하세요.
