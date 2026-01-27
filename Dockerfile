# Stage 1: Build React app
FROM node:18 AS react-build
WORKDIR /app/react

# Copy React app files
COPY bookmyshow-app/package*.json ./
RUN npm install

# Copy React source code
COPY bookmyshow-app/ ./

# Fix Node 18 OpenSSL issue
ENV NODE_OPTIONS=--openssl-legacy-provider

# Build React app
RUN npm run build

# Stage 2: Build Backend
FROM node:18-alpine AS backend-build
WORKDIR /app/backend

# Copy backend package files
COPY package*.json ./
RUN npm install --only=production

# Copy backend source
COPY server.js ./

# Stage 3: Final image
FROM node:18-alpine
WORKDIR /app

# Install backend dependencies
COPY --from=backend-build /app/backend/package*.json ./
COPY --from=backend-build /app/backend/node_modules ./node_modules
COPY --from=backend-build /app/backend/server.js ./

# Copy React build from stage 1
COPY --from=react-build /app/react/build ./bookmyshow-app/build

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
