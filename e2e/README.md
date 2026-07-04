# E2E 안전망 (RealWorld 공식 API 컬렉션 / Newman)

## 개념

이 디렉토리는 [RealWorld(Conduit)](https://github.com/gothinkster/realworld) 공식 API 스펙에 대한
Postman 컬렉션을 그대로 사용해, 백엔드가 스펙을 지키는지 검증하는 **안전망(safety net)**이다.

이 챌린지의 흐름은 "레거시 앱(app-legacy) → 마이그레이션 → 재구현(app-new)" 순으로 진행되며,
각 단계의 백엔드는 서로 다른 언어/프레임워크일 수 있다. 이 E2E는 특정 구현 방식이 아니라
**API 계약(contract)** 만을 검증하므로, 마이그레이션 결과와 재구현 결과 양쪽 모두에 대해
동일한 기준으로 실행할 수 있다.

> **재구현은 이 E2E에서 레거시 baseline이 통과하는 케이스(현재 388 assertion)를 회귀 없이
> 통과해야 "레거시와 동등하다"는 기준을 충족한 것으로 간주한다.** 아래 "알려진 제약"에
> 명시된, 레거시 자체의 한계로 실패하는 68개 갭(v2 스펙 미준수)은 재구현에서 반드시
> 해소해야 하는 것은 아니며, 추가로 해소하면 가점이다(스펙 준수도가 더 높아진다).

## 컬렉션 출처

- 원본: `gothinkster/realworld` 저장소의 `api/Conduit.postman_collection.json`
- 이 저장소는 2026년 초 API 테스트 스택을 Postman → Bruno/Hurl(API) + Playwright(E2E)로
  전환하면서 Postman 컬렉션을 저장소에서 완전히 제거했다. 따라서 삭제 직전 마지막 커밋
  (`5cd08ae2c0736473baf3584b63f22cd1cfb40257`, "api: updated to v2 with clear constraints for
  error management, updated the postman test collection to enforce")의 스냅샷을 그대로 받아왔다.
  이 커밋의 컬렉션은 RealWorld가 만들었던 것 중 가장 엄격한("v2") 버전이다.

## 실행법

```bash
# 1) 검증 대상 앱을 기동 (예: app-legacy)
cd app-legacy && docker compose up -d --build
# 로그에서 마이그레이션/시드 완료 및 "PHP ... started" 등 부팅 완료 메시지를 확인한다.

# 2) 저장소 루트로 이동 후 E2E 실행
cd ..
bash e2e/run-e2e.sh http://localhost:8080

# 3) 완전 초기화가 필요하면
cd app-legacy && docker compose down -v
```

`run-e2e.sh`는 인자로 base URL을 받는다(기본값 `http://localhost:8080`). 재구현 앱을 검증할 때는
`bash e2e/run-e2e.sh http://localhost:<재구현 포트>` 형태로 그대로 재사용한다.

## APIURL 규약

- 컬렉션 내부의 모든 요청은 `{{APIURL}}`을 base로 사용한다.
- `run-e2e.sh`는 `APIURL="<base_url>/api"`로 설정한다 (예: `http://localhost:8080/api`).
- 컬렉션은 `APIURL` 외에 `USERNAME` / `EMAIL` / `PASSWORD`도 외부 global-var로 요구한다
  (Register/Login 요청 본문에 `{{USERNAME}}` 등 리터럴 변수가 그대로 박혀 있고, 컬렉션
  자체에는 이를 채우는 pre-request 스크립트가 없다). `run-e2e.sh`는 RealWorld 공식
  `run-api-tests.sh`와 동일한 방식으로 매 실행마다 `USERNAME=u$(date +%s)` 형태의 유니크한
  계정을 생성해 주입한다. 이 값들을 채우지 않으면 Register 단계부터 422로 실패하고 이후
  전체가 연쇄 실패한다 — 실제로 초기 실행에서 이 문제로 156개 assertion 중 76개가 실패했고,
  누락을 바로잡은 뒤 456개 assertion 중 68개 실패로 좁혀졌다.

## Newman 실행 결과 (app-legacy, 클린 상태 기준)

```
requests:            86 executed,  0 failed
test-scripts:        110 executed, 23 failed
prerequest-scripts:  24 executed,  0 failed
assertions:          456 executed, 68 failed (388 통과)
total run duration:  ~22.5s
```

요청 레벨(HTTP 통신/연결)은 100% 성공했고, 실패는 전부 **assertion(스펙 세부 준수) 레벨**이다.
`docker compose down -v`로 완전히 초기화한 뒤 재실행해도 동일한 수치가 재현되므로, 아래는
일회성 오염이 아니라 app-legacy 구현 자체의 결정적(deterministic) 한계다.

## 알려진 제약 / 스킵 (레거시 구현의 한계 — 앱 소스는 수정하지 않음)

이 v2 컬렉션은 RealWorld 중에서도 가장 엄격한 버전이라, 오래된 slim 기반 legacy 구현이
아래 항목들을 통과하지 못한다. 원인을 각각 확인했다.

1. **타임스탬프에 소수점 이하 초가 없음** (약 24개 assertion)
   - 컬렉션은 `createdAt`/`updatedAt`이 `/^\d{4,}-..T..:..:..\.\d+(?:[+-]..:..|Z)$/` 정규식,
     즉 초 뒤에 반드시 `.밀리초`가 있는 ISO 8601을 기대한다.
   - app-legacy는 `"2026-07-04T00:00:31+00:00"`처럼 소수점 없는 형식을 반환한다.
   - `curl`로 직접 확인: 값 자체는 유효한 ISO 8601이지만 정규식이 요구하는 소수점 부분이 없어
     매칭 실패.

2. **미인증/미존재 리소스 오류 응답에 JSON `errors` 바디가 없음** (가장 큰 비중, JSONError +
   "Response has errors object" 실패 다수)
   - 컬렉션은 401/403/404 응답에도 항상 `{"errors": {...}}` 형태의 JSON 바디를 기대한다.
   - 실측 결과: 인증 없이 글 작성 시 `401`이지만 바디가 **0바이트**(`curl -s -X POST
     .../api/articles` → `STATUS:401 SIZE:0`), 인증 없이 피드 조회 시 `401`이지만 바디가
     `[]`(빈 배열, object 아님). 존재하지 않는 slug 조회(`GET /api/articles/unknown-slug`)는
     `404`이지만 바디가 JSON이 아니라 프레임워크 기본 **HTML 404 페이지**.
   - 즉 상태 코드 자체는 대체로 맞지만, 에러 바디 계약을 지키지 않는다.

3. **검증 에러 메시지 문구가 Rails 관례("can't be blank")와 다름**
   - 컬렉션은 빈 필드 검증 실패 메시지가 정확히 `"can't be blank"`이길 기대한다.
   - 실측: app-legacy는 `{"errors":{"title":["title must not be empty"], ...}}` 형태로
     `"XXX must not be empty"` 문구를 사용한다. 구조(422 + errors 객체 + 필드 키)는 맞지만
     문자열이 달라 exact-match assertion만 실패한다.

4. **상태 코드가 스펙과 다른 케이스**
   - 중복 이메일/유저명 가입: 컬렉션은 `409`를 기대하지만 app-legacy는 `422`를 반환한다
     (메시지 내용 `"has already been taken"`은 정확히 일치).
   - 로그인 비밀번호 오류: 컬렉션은 `401` + `errors.credentials`를 기대하지만 app-legacy는
     `422` + `errors["email or password"]`(합쳐진 키)를 반환한다.
   - 아티클 제목 중복: 컬렉션은 `409` 거부를 기대하지만 app-legacy는 아예 막지 않고 `200`으로
     성공시키며 슬러그에 `-2` 접미사를 붙여 우회한다(`dup-title-probe` → `dup-title-probe-2`).

5. **부팅 시 항상 무작위 데모 데이터가 시딩됨** (Pagination/전체 목록의 "정확히 2개" 계열
   assertion 실패)
   - `app-legacy/database/seeds/DataSeeder.php`가 기동 때마다 가짜 유저 20명과 유저당
     1~5개의 무작위 아티클, 댓글, 즐겨찾기, 팔로우 관계를 항상 생성한다.
   - 컬렉션의 일부 pagination 테스트(`articlesCount is exactly 2 (total, not page size)` 등)는
     "이 테스트가 만든 아티클만 존재하는" 격리된 데이터셋을 전제로 하는데, app-legacy는 이미
     시드된 다른 아티클들이 항상 섞여 있어 정확한 카운트 일치가 원천적으로 불가능하다. 이는
     테스트 설계와 앱의 데모 데이터 정책 간의 구조적 불일치이지, HTTP 계약 위반은 아니다.

6. **위 원인들의 연쇄(cascading) 실패**
   - 위 1~5번 중 하나가 실패하면 그 응답에서 파생되는 후속 값(예: `celeb_token`, `commentId`,
     `slug`)이 설정되지 않아, 같은 시나리오의 다음 요청들이 `TypeError: Cannot read properties
     of undefined` 또는 `JSONError`로 추가 실패한다. 실제 실패 건수(68개)에는 이런 연쇄분이
     포함되어 있어, "독립적인 결함 수"보다 assertion 실패 수가 더 많게 집계된다.

### 재구현 시 참고

재구현 단계에서 위 1~5번을 스펙대로 고치면(밀리초 포함 타임스탬프, 모든 에러 응답에 JSON
`errors` 바디, Rails 스타일 메시지, 올바른 상태 코드, 시드 데이터 없이 시작 또는 시드를
고려한 테스트 격리) 이 E2E가 완전히 그린이 될 수 있다. 즉 이 목록은 "재구현이 레거시보다
더 잘 지켜야 할 스펙 준수 체크리스트"로도 활용 가능하다.
