FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
COPY server.js ./
RUN npm install --only=production
COPY bookmyshow-app/build ./bookmyshow-app/build
EXPOSE 8080
CMD ["node", "server.js"]
