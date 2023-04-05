FROM node:18-alpine AS builder

WORKDIR /app 
#RUN chown -R node:node /app

COPY package.json /app

#ENV NPM_CONFIG_UNSAFE_PERM = true

RUN npm install

COPY . .

#RUN useradd -ms /bin/bash node
RUN adduser -S -D -h /usr/app/src node
RUN usermod -aG sudo node
RUN chown -R node:node /app
USER node

RUN npm run build

FROM node:18-alpine AS runner

WORKDIR /app

COPY --from=builder /app/.next/standalone ./.next/standalone
COPY --from=builder /app/.next/static ./.next/standalone/.next/static
COPY --from=builder /app/public ./.next/standalone/public

EXPOSE 3000

CMD [ "node", "./.next/standalone/server.js" ]

