#!/bin/bash

# Define variables
GIT_REPO_DIR="/root/Documents/elimbadi.io"   # Path to your Git repository
BRANCH_NAME="main"                            # The Git branch you are working on
IMAGE_NAME="my-go-app"                        # The name of your Docker image
CONTAINER_NAME="go-deployment"              # The name of your Docker container
HOST_PORT="8000"                              # Host port to expose
CONTAINER_PORT="8000"                         # Container port
DOCKERFILE_DIR="/root/Documents/elimbadi.io"     # Path to the Dockerfile directory (or current directory)

# Navigate to the Git repository
cd "$GIT_REPO_DIR" || exit

# Step 1: Pull the latest code from Git
echo "Pulling the latest code from Git..."
git pull origin "$BRANCH_NAME"

# Step 2: Rebuild the Docker image
echo "Rebuilding Docker image..."
docker build -t "$IMAGE_NAME:latest" "$DOCKERFILE_DIR"

# Step 3: Stop and remove the old Docker container
echo "Stopping and removing the old container..."
docker stop "$CONTAINER_NAME" || echo "Container not running."
docker rm "$CONTAINER_NAME" || echo "Container not found."

# Step 4: Run the new Docker container
echo "Running the new container..."
docker run -d -p "$HOST_PORT:$CONTAINER_PORT" --name "$CONTAINER_NAME" "$IMAGE_NAME:latest"

# Step 5: Clean up unused Docker images (optional)
echo "Cleaning up unused Docker images..."
docker image prune -f

echo "Deployment complete!"
