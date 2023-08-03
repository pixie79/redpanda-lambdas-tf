FROM golang:latest as build
WORKDIR /app

# Copy dependencies list
COPY . ./

# build
RUN go mod tidy
RUN go get
RUN GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap -tags lambda.norpc


## copy artifacts to a clean image
FROM public.ecr.aws/lambda/provided:latest-arm64
LABEL authors="markolliver"
COPY --from=build /app/bootstrap /bootstrap
RUN chmod +x /bootstrap
ENTRYPOINT [ "/bootstrap" ]
