# Attribution

이 디렉토리(`app-legacy/`)는 다음 오픈소스 저장소를 그대로 vendoring한 것입니다.

- **출처**: https://github.com/gothinkster/slim-php-realworld-example-app
- **원저작자**: gothinkster (실제 코드 작성자는 `composer.json` 기준 Hamoud Alhoqbani / alhoqbani)
- **vendoring 시점**: 2026-07-04, `main` 브랜치 최신 커밋 기준 `git clone --depth 1` (이후 `.git` 제거)

## 라이선스 관련 참고

**upstream에 LICENSE 파일 없음** → RealWorld 프로젝트 관례(MIT) 추정, 교육·채용 목적 사용. 라이선스 명확화는 후속 확인 대상.

참고로 `composer.json`의 `license` 필드에는 `"MIT"`로 명시되어 있어 MIT 추정을 뒷받침하나, 저장소 루트에 `LICENSE`/`LICENSE.md` 파일 자체는 존재하지 않습니다.

## 수정 여부

vendoring 시(Task 2) 코드 내용은 수정하지 않았습니다(`.git` 디렉토리만 제거).

### 실행을 위한 upstream 대비 변경 (Task 2b)

vendoring된 원본은 그대로 기동되지 않아, **실행 인프라만** 최소 변경했습니다. 앱의 라우트/모델 등 비즈니스 로직은 변경하지 않았습니다.

- **`Dockerfile` 신규 추가**: `php:7.4-cli` 기반, `pdo`/`pdo_mysql`/`zip` 확장 설치, composer 공식 이미지에서 바이너리 복사, `composer install`(dev 의존성 포함) 실행.
- **`docker-entrypoint.sh` 신규 추가**: DB 포트 대기 → `phinx migrate` → `phinx seed:run` → 원래 커맨드(`php -S 0.0.0.0:8080 -t public public/index.php`) 실행.
- **`.dockerignore` 신규 추가**: `vendor/`, `.env`, `.git`, `logs/*` 제외(호스트 트라이얼 산출물이 이미지 빌드에 섞이지 않도록).
- **`docker-compose.yml` 재작성**: 기존 `slim` 단일 서비스(이미지 그대로 서빙, DB 없음)를 `db`(mariadb:10.5) + `app`(위 Dockerfile 빌드) 2-서비스 구성으로 교체. DB 접속 정보는 `.env` 파일이 아니라 `app.environment`로 주입(개발용 더미 값, 실제 시크릿 아님). 포트 `8080:8080`은 유지.
- **`composer.json`**:
  - `robmorgan/phinx: dev-master#4c26aeb`(더 이상 존재하지 않는 커밋) → `^0.12.13`(PHP 7.4 및 현재 다른 의존성과 호환되는 실제 릴리즈)로 교체.
  - `slim/slim: ^3.9` → `>=3.9,<3.12.3`으로 상한 고정. 사유: slim/slim이 3.12.2→3.12.3 사이에 `Slim\Container`의 구현 인터페이스를 `Interop\Container\ContainerInterface`에서 `Psr\Container\ContainerInterface`로 교체했는데, 앱 자체 미들웨어(`src/Conduit/Middleware/OptionalAuth.php`)가 구 인터페이스로 타입힌트되어 있어 `^3.9`만 지정하면 최신 3.12.5가 설치되어 타입 에러가 발생함. `src/` 수정 대신 버전 상한으로 구 인터페이스 구현체를 유지하는 쪽을 선택.
  - 빌드 시 `COMPOSER_NO_BLOCKING=1`로 composer 2.6+의 취약점 차단 정책을 우회(phpunit ^6.4·firebase/php-jwt 구버전 등 2018년 전후 pin이 최신 보안 권고에 걸리는 문제; 앱이 교육/과제용 vendoring임을 감안해 차단만 해제하고 버전 자체는 그대로 둠). `composer.lock`은 이미지 안에서만 생성되며 리포에는 커밋하지 않음.
- **`database/generator/BaseMigration.php`, `database/BaseSeeder.php`**: `init()` 메서드 가시성을 `protected` → `public`으로 변경(1줄씩, 총 2곳). 사유: 최신 phinx(0.12.13)의 `Environment` 클래스가 `method_exists()` 확인 후 `$migration->init()`/`$seed->init()`을 클래스 외부에서 직접 호출하는 구조로 바뀌어, `protected`로 선언되어 있으면 치명적 오류가 남. 두 파일 모두 `src/`가 아닌 `database/`(마이그레이션·시더 스캐폴드) 소속이며 비즈니스 로직(라우트/모델)이 아님. 동작(스키마 생성, 팩토리 초기화) 자체는 변경하지 않음.

### 기동·검증 결과 (실측)

`docker compose up -d --build` 후:
- `GET /api/tags` → `HTTP 200` + `{"tags":[...]}` (seed 데이터 8개 태그)
- `POST /api/users`(회원가입) → `HTTP 200` + 생성된 사용자 JSON(JWT 토큰 포함) — DB 쓰기까지 정상 동작 확인.

상세 로그는 태스크 보고서(`scratchpad/sdd/task-2-report.md`의 "Task 2b" 절)에 기록.
