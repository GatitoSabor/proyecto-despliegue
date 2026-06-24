FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --include=dev && ls node_modules/.bin/
COPY . .
RUN npm run build

FROM nginx:alpine
RUN apk add --no-cache ca-certificates gettext
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
