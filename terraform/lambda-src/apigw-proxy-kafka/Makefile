coverage:
	go test -coverpkg=./... ./...

test:
	go test -v ./... ./...

tidy:
	goimports -v -w .


tools:
	go mod tidy
	go install golang.org/x/tools/cmd/goimports@latest
	go install golang.org/x/tools/cmd/godoc@latest

lint:
	golangci-lint -v run

docs:
	godoc -http=localhost:8080 -index -index_interval=10s -play -notes=BUG


lambda:
	GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap -tags lambda.norpc
	zip -v1 bootstrap.zip bootstrap

docker_build:
	docker build -t docker-image:lambda_test .

get_re:
	mkdir -p ~/.aws-lambda-rie && \
        curl -Lo ~/.aws-lambda-rie/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie && \
        chmod +x ~/.aws-lambda-rie/aws-lambda-rie

get_re_arm:
	mkdir -p ~/.aws-lambda-rie && \
		curl -Lo ~/.aws-lambda-rie/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie-arm64
		chmod +x ~/.aws-lambda-rie/aws-lambda-rie

docker_run:

	docker run -v ~/.aws-lambda-rie:/aws-lambda --env-file .env --env-file .env.docker -it --name lambda_test -p 9000:8080 --entrypoint /aws-lambda/aws-lambda-rie docker-image:lambda_test /bootstrap && \
	docker stop lambda_test && \
	docker rm lambda_test

clean:
	docker rmi docker-image:lambda_test

docker_logs:
	docker logs -f lambda_test

event_kafka_trigger:
	curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"eventSource":"SelfManagedKafka","eventSourceArn":"","records":{"10x-client-message-reconciliation-interval-v001-4":[{"topic":"10x-client-message-reconciliation-interval-v001","partition":4,"offset":220460,"timestamp":1687414815625,"timestampType":"CREATE_TIME","key":"AAAAAhACXmNsaWVudC1wYXltZW50cy1hdS1ucHAtY2xlYXJpbmctZmlsZS1ldmVudC12MDAx","value":"AAAAACCA0u+bnGLAoZScnGJeY2xpZW50LXBheW1lbnRzLWF1LW5wcC1jbGVhcmluZy1maWxlLWV2ZW50LXYwMDEAAAA=","headers":[{"b3":[78,106,81,53,77,50,85,52,77,87,89,48,78,68,107,53,79,84,82,106,78,68,90,105,90,106,100,109,90,71,85,53,90,106,86,106,90,71,81,50,78,122,103,116,78,109,74,109,78,50,90,107,90,84,108,109,78,87,78,107,90,68,89,51,79,67,48,120]}]}]},"bootstrapServers":"seed-2d993ff6.cgvroei80qtl7p20ouq0.byoc.prd.cloud.redpanda.com:9092"}'

event_apigw_trigger:
	curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'

event:
	curl -XPOST "https://8f4xhqkaxk.execute-api.eu-west-2.amazonaws.com/event/payment" -d '{"key1": "value1","key2": "value2","key3": "value3"}' -H "Content-Type: application/vnd.kafka.v2+json" -i
