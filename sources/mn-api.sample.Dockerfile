FROM node:${NODE_VERSION}
WORKDIR /api
RUN apk add --update --no-cache \
    make \
    g++ \
    jpeg-dev \
    cairo-dev \
    giflib-dev \
    pango-dev \
    libtool \
    autoconf \
    automake
COPY ./mn-api/package.json /api/package.json
RUN npm i
COPY ./mn-api /api/app
CMD ["ng", "serve"]