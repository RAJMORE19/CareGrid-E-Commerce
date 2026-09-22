FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY --chown=node:node . .
USER node
EXPOSE 5003
CMD ["node", "server.js"]
