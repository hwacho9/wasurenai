# MOTTA 랜딩페이지 호스팅 가이드

## 파일 구조

```
web/
├── landing.html          # 메인 랜딩페이지
├── privacy.html          # 프라이버시 정책
├── terms.html           # 이용약관
├── styles.css           # 공통 스타일시트
├── favicon.png          # 파비콘
├── manifest.json        # 웹 앱 매니페스트
└── icons/              # 앱 아이콘들
    ├── Icon-192.png
    └── Icon-512.png
```

## Firebase 호스팅 배포

### 1. Firebase CLI 설치 및 로그인

```bash
npm install -g firebase-tools
firebase login
```

### 2. 프로젝트 설정 확인

```bash
firebase projects:list
firebase use [프로젝트-ID]
```

### 3. 호스팅 배포

```bash
# 전체 배포 (hosting + functions)
firebase deploy

# 호스팅만 배포
firebase deploy --only hosting

# 미리보기
firebase hosting:channel:deploy preview-channel
```

### 4. 로컬 테스트

```bash
firebase serve
```

## 주요 기능

### 랜딩페이지 (landing.html)

-   **반응형 디자인**: 모바일, 태블릿, 데스크톱 지원
-   **SEO 최적화**: 메타 태그, 오픈 그래프, 트위터 카드
-   **애니메이션**: 스크롤 시 나타나는 요소들
-   **다운로드 링크**: App Store, Google Play 버튼
-   **연락처 정보**: 푸터에 포함

### 프라이버시 정책 (privacy.html)

-   GDPR, CCPA, 개인정보보호법 준수
-   상세한 정보 수집 및 사용 내역
-   사용자 권리 명시

### 이용약관 (terms.html)

-   서비스 이용 조건
-   금지 사항
-   책임 제한
-   분쟁 해결

## 커스터마이징

### 색상 변경

`styles.css`에서 주요 색상 변수들:

-   Primary: `#ff6b6b`
-   Secondary: `#ff8e8e`
-   Background: `#f8f9fa`

### 콘텐츠 수정

1. **앱 스크린샷**: `landing.html`의 phone-mockup 부분에 실제 이미지 추가
2. **다운로드 링크**: App Store, Google Play 실제 URL로 변경
3. **연락처**: 실제 이메일 주소로 변경
4. **소셜 미디어**: 실제 SNS 링크로 변경

### 도메인 설정

Firebase 콘솔에서 사용자 정의 도메인 설정:

1. Firebase 콘솔 → Hosting
2. "사용자 정의 도메인 추가" 클릭
3. 도메인 확인 및 DNS 설정

## SEO 최적화

### 메타 태그

-   제목, 설명, 키워드 설정
-   오픈 그래프 이미지 추가
-   구조화된 데이터 마크업

### 성능 최적화

-   이미지 압축 및 WebP 형식 사용
-   CSS/JS 압축
-   CDN 사용 (Firebase Hosting 기본 제공)

### 분석 도구

Google Analytics, Search Console 연동 권장

## 보안 설정

### 호스팅 헤더

```json
{
    "headers": [
        {
            "source": "**",
            "headers": [
                {
                    "key": "X-Frame-Options",
                    "value": "SAMEORIGIN"
                },
                {
                    "key": "X-Content-Type-Options",
                    "value": "nosniff"
                }
            ]
        }
    ]
}
```

### HTTPS 강제

Firebase Hosting은 기본적으로 HTTPS를 강제합니다.

## 문제 해결

### 배포 실패 시

1. Firebase CLI 버전 확인: `firebase --version`
2. 프로젝트 권한 확인
3. `firebase.json` 설정 검토

### 캐시 문제

```bash
# 캐시 우회 배포
firebase deploy --only hosting --force
```

### 도메인 연결 문제

1. DNS 설정 확인
2. SSL 인증서 상태 확인
3. Firebase 콘솔에서 도메인 상태 점검

## 유지보수

### 정기 업데이트 항목

-   [ ] 이용약관 및 프라이버시 정책
-   [ ] 앱 스크린샷
-   [ ] 다운로드 링크
-   [ ] 연락처 정보
-   [ ] 보안 헤더

### 모니터링

-   Google Analytics를 통한 트래픽 분석
-   Firebase 콘솔에서 호스팅 메트릭 확인
-   사용자 피드백 수집

## 연락처

기술적 문의: tech@motta.app
일반 문의: support@motta.app
