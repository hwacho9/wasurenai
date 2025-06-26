# GymLinker Landing Page

GymLinker 앱을 위한 현대적이고 반응형 랜딩 페이지입니다.

## 📱 프로젝트 개요

GymLinker는 사용자의 피트니스 여정을 기록하고 친구들과 모티베이션을 공유할 수 있는 모바일 앱입니다. 이 랜딩 페이지는 앱의 주요 기능들을 소개하고 사용자들에게 다운로드를 유도하는 목적으로 제작되었습니다.

## ✨ 주요 기능

-   **반응형 디자인**: 모든 디바이스에서 완벽하게 작동
-   **모던한 UI/UX**: 그라디언트와 애니메이션을 활용한 시각적 효과
-   **인터랙티브 요소**: 스크롤 애니메이션, 타이핑 효과, 패럴랙스
-   **모바일 친화적**: 터치 디바이스에 최적화된 네비게이션
-   **SEO 최적화**: 검색 엔진에 친화적인 구조

## 🛠 기술 스택

-   **HTML5**: 시맨틱 마크업
-   **CSS3**: Flexbox, Grid, 애니메이션
-   **JavaScript**: ES6+, Intersection Observer API
-   **Font Awesome**: 아이콘
-   **Google Fonts**: Noto Sans JP 폰트

## 📋 페이지 구성

1. **헤더 (Header)**

    - 고정 네비게이션
    - 모바일 햄버거 메뉴

2. **히어로 섹션 (Hero)**

    - 메인 캐치프레이즈: "筋トレはこれで完璧！"
    - 앱 스크린 목업
    - 다운로드 버튼

3. **기능 소개 (Features)**

    - 4가지 주요 기능 카드
    - 호버 애니메이션

4. **제품 소개 (Product)**

    - 앱 스크린샷과 설명
    - 좌우 교차 레이아웃

5. **연락처 (Contact)**

    - 이메일: gymlinker.service@gmail.com
    - 인스타그램: @GymLinker
    - 문의 및 신고 섹션

6. **푸터 (Footer)**
    - 저작권 정보
    - 정책 링크

## 🚀 Firebase 배포 방법

### 1. Firebase CLI 설치

```bash
npm install -g firebase-tools
```

### 2. Firebase 로그인

```bash
firebase login
```

### 3. Firebase 프로젝트 초기화

```bash
firebase init hosting
```

### 4. 배포

```bash
firebase deploy
```

## 📱 미리보기

### 데스크톱

-   2열 그리드 레이아웃
-   풀사이즈 히어로 섹션
-   호버 효과 및 애니메이션

### 모바일

-   단일 열 레이아웃
-   햄버거 메뉴
-   터치 친화적 인터페이스

## 🎨 디자인 특징

### 색상 팔레트

-   **Primary**: #6366f1 (인디고)
-   **Secondary**: #4ade80 (그린)
-   **Gradient**: #667eea → #764ba2

### 애니메이션

-   **타이핑 효과**: 히어로 타이틀
-   **패럴랙스**: 배경 도형
-   **페이드인**: 섹션별 스크롤 애니메이션
-   **호버 효과**: 카드 및 버튼

## 📝 커스터마이징

### 색상 변경

`styles.css` 파일의 CSS 변수를 수정하세요:

```css
:root {
    --primary-color: #6366f1;
    --secondary-color: #4ade80;
    --gradient-start: #667eea;
    --gradient-end: #764ba2;
}
```

### 콘텐츠 수정

`index.html` 파일에서 텍스트 내용을 직접 편집할 수 있습니다.

### 애니메이션 조정

`script.js` 파일에서 애니메이션 타이밍과 효과를 조정할 수 있습니다.

## 🌐 브라우저 지원

-   Chrome (최신)
-   Firefox (최신)
-   Safari (최신)
-   Edge (최신)
-   iOS Safari
-   Chrome Mobile

## 📊 성능 최적화

-   **이미지 최적화**: WebP 형식 사용 권장
-   **CSS 압축**: 프로덕션 배포 시 압축 필요
-   **JavaScript 압축**: 프로덕션 배포 시 압축 필요
-   **캐싱**: Firebase Hosting 자동 캐싱 적용

## 🐛 알려진 이슈

-   IE11 이하 버전에서는 일부 CSS 기능이 지원되지 않음
-   저사양 디바이스에서 애니메이션 성능 저하 가능

## 📞 문의사항

프로젝트에 대한 문의사항이나 개선 제안이 있으시면 연락주세요:

-   이메일: gymlinker.service@gmail.com
-   인스타그램: @GymLinker

## 📄 라이선스

이 프로젝트는 GymLinker 팀의 소유입니다. 모든 권리가 보호됩니다.

---

**GymLinker** - 筋トレはこれで完璧！
