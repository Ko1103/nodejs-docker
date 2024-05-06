# Best Practice Node.js Dockerfile

[Japanese/日本語はこちら](https://github.com/Ko1103/nodejs-docker/blob/main/README.japanese.md)

This repository summarizes best practices for creating a Dockerfile for Node.js.

Below are explanations for each best practice:

## 1. Use even version for the base image

Node.js even versions are LTS (Long Term Support) versions. Therefore, it is recommended to use an even version for the base image.

## 2. Set the working directory

Setting the working directory makes it easier to work within the container. Also, setting permissions on the directory can enhance security.

## 3. Optimize package installation

Optimizing package installation can shorten build times. Also, by leveraging Docker layer caching, build reruns can be sped up.
As an example in the Dockerfile, copying `package.json` and `package-lock.json` files and performing package installation afterward, followed by copying other files, ensures that package installation occurs only if these files are changed.

## 4. Use mounted npmrc file

Directly copying the npmrc file into the Dockerfile poses a security risk, so it's recommended to use the npmrc file by mounting it.
Additionally, it's recommended to avoid including environment variables needed during build time in the Docker layer whenever possible.

## 5. Utilize multi-stage builds

For TypeScript projects and others, building what's necessary during the build phase in a separate container and creating a container containing only what's needed during runtime can reduce image size.

## 6. Use a small base container for production stage

While build tools are necessary during build time, they are unnecessary for running servers in production. Therefore, it's recommended to use an image containing build tools during build time and an image without them for running servers in production. For Node.js, using small images like `alpine` or `slim` is recommended.

## 7. Set NODE_ENV

Some Node.js tools behave differently when NODE_ENV is set to production. Therefore, setting NODE_ENV is recommended.

## 8. Set User

Docker containers run by default as the root user, but this poses security risks, so setting a User is recommended.

## 9. Remove packages not used in production

By removing packages not used in production, image size can be reduced. This can be achieved by using `npm prune --production` or `npm ci --only=production`.

## 10. Export ports

Explicitly setting ports that can be accessed from outside the container enhances security.

## 11. Start with Node command

Using npm command during startup may cause issues with signal handling when shutting down Docker containers, as npm scripts may launch servers as child processes. Therefore, it's recommended to start servers with the Node command. If difficult, tools like `tini` are recommended.
