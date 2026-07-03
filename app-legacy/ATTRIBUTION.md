# Attribution

이 디렉토리(`app-legacy/`)는 다음 오픈소스 저장소를 그대로 vendoring한 것입니다.

- **출처**: https://github.com/gothinkster/slim-php-realworld-example-app
- **원저작자**: gothinkster (실제 코드 작성자는 `composer.json` 기준 Hamoud Alhoqbani / alhoqbani)
- **vendoring 시점**: 2026-07-04, `main` 브랜치 최신 커밋 기준 `git clone --depth 1` (이후 `.git` 제거)

## 라이선스 관련 참고

**upstream에 LICENSE 파일 없음** → RealWorld 프로젝트 관례(MIT) 추정, 교육·채용 목적 사용. 라이선스 명확화는 후속 확인 대상.

참고로 `composer.json`의 `license` 필드에는 `"MIT"`로 명시되어 있어 MIT 추정을 뒷받침하나, 저장소 루트에 `LICENSE`/`LICENSE.md` 파일 자체는 존재하지 않습니다.

## 수정 여부

vendoring 시 코드 내용은 수정하지 않았습니다(`.git` 디렉토리만 제거). 기동 검증 중 발견된 이슈는 이 디렉토리를 수정하지 않고 `docker-compose.yml`, `composer.json` 등 원본 그대로 유지한 채 별도로 기록했습니다(레포 루트 문서 참고).
