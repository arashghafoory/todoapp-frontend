
FROM node:18-alpine AS build
WORKDIR /app
COPY . .

ARG API_BASE_URL
ENV API_BASE_URL=$API_BASE_URL

RUN npm install
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

