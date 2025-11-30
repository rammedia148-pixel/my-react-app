FROM node:18-alpine

WORKDIR /app

# Copy project files
COPY package*.json ./
RUN npm install

COPY . .

# Build Vite app → output in /app/dist
RUN npm run build

# Install serve globally to serve static files
RUN npm install -g serve

EXPOSE 3000

# Serve static files from dist

CMD ["serve", "-s", "dist", "-l", "3000"]

