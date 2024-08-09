FROM golang:1.22.0-bullseye as build

WORKDIR /go/src/app
COPY . .

# CGO_ENABLED is critial to successfully running dlv in static distro
RUN CGO_ENABLED=0 go install github.com/go-delve/delve/cmd/dlv@latest
RUN go mod download
RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build --trimpath -gcflags="all=-N -l" -o /go/bin/app

FROM gcr.io/distroless/base-nossl-debian12:debug AS runner

COPY --from=build /go/bin /go/bin
COPY --from=build /go/pkg /go/pkg

EXPOSE 8080 2345

ENTRYPOINT ["/go/bin/dlv"]