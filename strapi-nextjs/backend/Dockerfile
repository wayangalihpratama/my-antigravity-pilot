FROM node:20-alpine

# Set environment to development
ENV NODE_ENV=development

# Create app directory
WORKDIR /opt/app

# Install dependencies (will be overridden by volume in dev, but needed for initial setup)
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Build the admin panel
RUN npm run build

# Expose the default Strapi port
EXPOSE 1337

# Start the application in develop mode
CMD ["npm", "run", "develop"]
