FROM node:alpine

COPY package.json package.json

RUN npm install

COPY index.html index.html
COPY index.js index.js

EXPOSE 3000

CMD ["npm", "start"]