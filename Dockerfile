FROM node:16 AS build

WORKDIR /home/node
COPY "package.json" "package-lock.json" "./"
RUN --mount=type=secret,id=npm,target=/root/.npmrc npm ci # if you dont need npmrc secret, RUN npm ci
COPY . .
RUN npm run build


FROM node:16-slim

USER node
EXPOSE 8080

WORKDIR /home/node
COPY --from=build --chown=node:node \
    /home/node/package.json \
    /home/node/package-lock.json \
    /home/node/node_modules \
    .
COPY --from=build --chown=node:node \
    /home/node/dist \
    ./dist
RUN npm prune --production

CMD [ "node", "dist/index.js" ]
