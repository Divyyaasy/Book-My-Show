# Single stage Dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy backend files
COPY package*.json ./
COPY server.js ./

# Install backend dependencies
RUN npm install --only=production

# Copy React build
COPY bookmyshow-app/build ./bookmyshow-app/build

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
