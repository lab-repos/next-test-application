FROM node:18-alpine AS builder

WORKDIR /app 

COPY package.json /app

RUN npm install

COPY . .
###
RUN useradd -ms /bin/bash node
RUN usermod -aG sudo node
RUN chown -R node:node /app
USER node
###
RUN npm run build

FROM node:18-alpine AS runner

WORKDIR /app

COPY --from=builder /app/.next/standalone ./.next/standalone
COPY --from=builder /app/.next/static ./.next/standalone/.next/static
COPY --from=builder /app/public ./.next/standalone/public

EXPOSE 3000

CMD [ "node", "./.next/standalone/server.js" ]

