FROM node:20-alpine

# Set environment to development
ENV NODE_ENV=development

# Create app directory
WORKDIR /opt/app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the default Next.js port
EXPOSE 3000

# Start the application in dev mode
CMD ["npm", "run", "dev"]
