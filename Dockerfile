FROM node:16 AS build

WORKDIR /home/node
COPY package.json package-lock.json .
# if you dont need npmrc secret, RUN npm ci
RUN --mount=type=secret,id=npm,target=/root/.npmrc npm ci
COPY . .
RUN npm run build


FROM node:16-slim

USER node

WORKDIR /home/node
COPY --from=build --chown=node:node /home/node/node_modules node_modules
COPY --from=build --chown=node:node /home/node/package*.json .
COPY --from=build --chown=node:node /home/node/dist dist
RUN npm prune --production

EXPOSE 8080
CMD [ "node", "dist/index.js" ]
