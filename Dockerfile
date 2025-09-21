# Dockerfile para Auth API (Go 1.18.2)
FROM golang:1.18.2-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

ENV GO111MODULE=on

COPY go.mod go.sum ./

RUN go mod init github.com/bortizf/microservice-app-example/tree/master/auth-api || true
RUN go mod tidy
RUN go mod download

COPY . .

RUN go build -o auth-api .

# Runtime
FROM alpine:latest

# Instalar certificados SSL y herramientas básicas
RUN apk --no-cache add ca-certificates wget

WORKDIR /root/

COPY --from=builder /app/auth-api .

EXPOSE 80

#ENV JWT_SECRET=PRFT
#ENV AUTH_API_PORT=8000
#ENV USERS_API_ADDRESS=http://127.0.0.1:8083

CMD ["./auth-api"]