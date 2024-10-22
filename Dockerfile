FROM node:20.17.0 AS base
WORKDIR /app

FROM base AS client-base
COPY client/package.json ./
RUN npm install --omit-dev
COPY client/eslint.config.js client/index.html client/vite.config.js ./
COPY client/src ./src

FROM client-base AS client-build
RUN npm run build

FROM base AS final
ENV NODE_ENV=production
COPY backend/package.json ./
RUN npm install --omit-dev
COPY backend/server.js ./src/
COPY --from=client-build /app/dist/ ./src/static
EXPOSE 3000
CMD ["node", "src/server.js"]