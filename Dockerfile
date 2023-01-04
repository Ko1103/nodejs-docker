FROM node:16 AS build

COPY "package.json" "package-lock.json" "./"
RUN --mount=type=secret,id=npm,target=/root/.npmrc npm ci # if you dont need npmrc secret, RUN npm ci
COPY . .
RUN npm run build


FROM node:slim-16

USER node
EXPOSE 8080

COPY --from=build /home/node/app/dist /home/node/app/package.json /home/node/app/package-lock.json  /home/node/app/node_modules ./
RUN npm prune --production

CMD [ "node", "dist/app.js" ]
