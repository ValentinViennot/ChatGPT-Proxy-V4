# Use the official Go image as the base image
FROM golang:latest AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go mod and sum files to the container
COPY go.mod go.sum ./

# Download all dependencies. 
# This step will be skipped if go.mod and go.sum haven't changed since last build.
RUN go mod download

# Copy the source code to the container
COPY . .

# Build the Go app (statically compiled)
RUN CGO_ENABLED=0 go build -o app .

FROM gcr.io/distroless/static

COPY --from=builder /app/app /app

# Expose the port that the app listens on
EXPOSE 8080
# ChatGPT access token, get from https://chat.openai.com/api/auth/session
ENV ACCESS_TOKEN=your-secret-access-token
# ChatGPT Plus Personal User ID, get from Webchat Cookies
ENV PUID=your-personal-chatgptplus-puid

# Run the app when the container starts
CMD ["/app"]
