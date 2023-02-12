FROM node:${NODE_VERSION} AS build
COPY mb-app/package*.json /mb/
WORKDIR /mb
RUN npm install
COPY mb-app .
RUN npm run build

FROM nginx:latest
ARG ENV
COPY --from=build /mb/dist/* /usr/share/nginx/html/
COPY nginx.mb-app.conf /etc/nginx/
#COPY config-mb-app-$ENV.json /usr/share/nginx/html/assets/config.json
CMD [ "nginx", "-g", "daemon off;" ]