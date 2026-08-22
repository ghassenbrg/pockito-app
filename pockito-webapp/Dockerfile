# The Nuxt app is a browser client, so its configuration is baked in at build time and is
# public by definition. Build args, not runtime secrets.
FROM node:22-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

ARG NUXT_APP_BASE_URL=/app/
ARG NUXT_PUBLIC_API_BASE_URL=https://pockito.ghassen.io/api/v1
ARG NUXT_PUBLIC_KEYCLOAK_ISSUER=https://auth.ghassen.io/realms/pockito
ARG NUXT_PUBLIC_KEYCLOAK_CLIENT_ID=pockito-webapp
ENV NUXT_APP_BASE_URL=$NUXT_APP_BASE_URL \
    NUXT_PUBLIC_API_BASE_URL=$NUXT_PUBLIC_API_BASE_URL \
    NUXT_PUBLIC_KEYCLOAK_ISSUER=$NUXT_PUBLIC_KEYCLOAK_ISSUER \
    NUXT_PUBLIC_KEYCLOAK_CLIENT_ID=$NUXT_PUBLIC_KEYCLOAK_CLIENT_ID
RUN npm run build

FROM node:22-alpine
WORKDIR /app
RUN addgroup -S pockito && adduser -S -G pockito pockito
COPY --from=build --chown=pockito:pockito /app/.output ./
USER pockito
ENV NITRO_PORT=3000 NITRO_HOST=0.0.0.0
EXPOSE 3000
CMD ["node", "server/index.mjs"]
