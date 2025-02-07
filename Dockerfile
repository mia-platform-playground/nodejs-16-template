FROM node:16.15.0-alpine as build

ARG COMMIT_SHA=<not-specified>
ENV NODE_ENV=production

WORKDIR /build-dir

COPY package.json .
COPY package-lock.json .

RUN npm ci

COPY . .

RUN echo "nodejs-16-template: $COMMIT_SHA" >> ./commit.sha

########################################################################################################################

FROM node:16.15.0-alpine

LABEL maintainer="jacopo.stefani@mia-platform.eu" \
      name="nodejs-16-template" \
      description="This is the best template to start creating a service in Node.js 16 integrated inside the platform" \
      eu.mia-platform.url="https://www.mia-platform.eu" \
      eu.mia-platform.version="0.1.0"

ENV NODE_ENV=production
ENV LOG_LEVEL=info
ENV SERVICE_PREFIX=/
ENV HTTP_PORT=3000

WORKDIR /home/node/app

COPY --from=build /build-dir ./

USER node

CMD ["npm", "-s", "start", "--", "--port", "${HTTP_PORT}", "--log-level", "${LOG_LEVEL}", "--prefix=${SERVICE_PREFIX}"]
