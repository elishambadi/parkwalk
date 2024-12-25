# Step 1: Use the official Golang image to build your app
FROM golang:1.23-alpine AS builder

# install node and npm
RUN apk add --no-cache nodejs npm

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the Go modules and download dependencies
COPY go.mod ./
RUN go mod tidy

# Step 4: Copy the entire application code (including templates)
COPY . .

WORKDIR /app
RUN npm install
RUN npm run build

# Step 5: Build the Go app from the cmd/server directory
WORKDIR /app/cmd/server
RUN go build -o /usr/local/bin/myapp .

# Step 6: Use a smaller image for the final image to run the app
FROM alpine:latest

RUN apk add --no-cache ca-certificates

# Step 7: Copy the binary from the builder image
COPY --from=builder /usr/local/bin/myapp /usr/local/bin/myapp

# Step 8: Copy the templates folder to the final image
COPY --from=builder /app/templates /app/templates

COPY --from=builder /app/assets /app/assets

# Step 9: Expose the port your app runs on
EXPOSE 8000

# Step 10: Run the application
CMD ["myapp"]
