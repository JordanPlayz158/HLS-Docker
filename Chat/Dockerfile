FROM node:alpine

COPY package.json package.json

RUN npm install

COPY index.html index.html
COPY index.js index.js

EXPOSE 3001

CMD ["npm", "start"]