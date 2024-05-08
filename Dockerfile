# 1단계: Node.js 베이스 이미지 사용
FROM node:18-alpine as build

# 작업 디렉터리 설정
WORKDIR /app

# yarn 설치 및 yarn berry 설정
RUN yarn set version berry

# 프로젝트 의존성 파일과 전체 프로젝트 복사
COPY . /app

# 프로젝트 의존성 설치
RUN yarn install

# 애플리케이션 빌드
RUN yarn build

# 2단계: 프로덕션 환경을 위한 경량 이미지 사용
FROM nginx:alpine

# 빌드된 정적 파일을 nginx 서버로 복사
COPY --from=build /app/build /usr/share/nginx/html

# nginx의 기본 포트를 노출
EXPOSE 80

# nginx 실행
CMD ["nginx", "-g", "daemon off;"]