# Use Node.js 18 lightweight image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the project files
COPY . .

# Build the NestJS project
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Start the app in production mode
CMD ["node", "dist/main"]
