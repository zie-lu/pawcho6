# syntax=docker/dockerfile:1    # Enable BuildKit syntax

FROM golang:alpine AS builder

WORKDIR /app

# Konfiguracja SSH dla klonowania repozytorium
RUN apk add --no-cache git openssh-client
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Kopiowanie klucza SSH (należy go dodać podczas budowania)
RUN --mount=type=ssh git clone git@github.com:zie-lu/pawcho6.git .

COPY main.go .
RUN go build -o app main.go

FROM scratch

COPY --from=builder /app/app /app

ARG VERSION
ENV VERSION=${VERSION}

EXPOSE 8080

CMD ["/app"]