FROM node:16-alpine AS base
RUN mkdir -p /usr/app
WORKDIR /usr/app

FROM base AS build-backend
COPY ./ ./
RUN npm ci
RUN npm run build

FROM base AS release
COPY --from=build-backend /usr/app/dist ./
COPY ./package.json ./
COPY ./package-lock.json ./
RUN npm ci --only=production

ENTRYPOINT [ "node", "index" ]
