# مرحله build
FROM node:18-alpine AS build
WORKDIR /app
COPY . .

# تعریف متغیر در زمان بیلد
ARG REACT_APP_API_BASE_URL
ENV REACT_APP_API_BASE_URL=$REACT_APP_API_BASE_URL

RUN npm install
RUN npm run build

# مرحله سروینگ
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

