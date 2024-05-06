# Practice 1
FROM node:16 AS build

# Practice 2
WORKDIR /home/node

# Practice 3
COPY package.json package-lock.json .
# Practice 4
# if you dont need npmrc secret, RUN npm ci
RUN --mount=type=secret,id=npm,target=/root/.npmrc npm ci #
COPY . .
RUN npm run build


# Practice 5,6
FROM node:16-slim
# Practice 7
ENV NODE_ENV=production

WORKDIR /home/node
COPY --from=build --chown=node:node /home/node/node_modules node_modules
COPY --from=build --chown=node:node /home/node/package*.json .
COPY --from=build --chown=node:node /home/node/dist dist

# Practice 8
USER node
# Practice 9
RUN npm prune --production

# Practice 10
EXPOSE 8080
# Practice 11
CMD [ "node", "dist/index.js" ]
