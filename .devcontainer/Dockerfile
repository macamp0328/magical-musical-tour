# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json into the directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Install TypeScript globally in the container
RUN npm install -g typescript

# Copy the current directory contents into the container at /app
COPY . .

# Compile TypeScript into JavaScript
RUN tsc

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run the app when the container launches
CMD ["npm", "start"]