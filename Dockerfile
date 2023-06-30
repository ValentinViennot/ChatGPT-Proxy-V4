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
EXPOSE 9090

# OpenAI credentials
ENV OPENAI_EMAIL=user@example.com
ENV OPENAI_PASSWORD=ultrasecretpassword

# ENV GIN_MODE=release

# Run the app when the container starts
CMD ["/app"]
