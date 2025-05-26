# Stage 1: Build
FROM node:18-alpine AS build
WORKDIR /app

# Copy source
COPY . .

# Pass build argument and set environment variable
ARG API_BASE_URL
ENV API_BASE_URL=${API_BASE_URL}

# Print the API_BASE_URL during build for debugging
RUN echo "[Build] API_BASE_URL is: ${API_BASE_URL}"

# Install dependencies and build the app
RUN npm install
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy build output
COPY --from=build /app/build /usr/share/nginx/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
