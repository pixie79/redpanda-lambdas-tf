// Copyright Pixie79
// All Rights Reserved
// Distributed under the terms of the MIT License.

// Package main - an AWS Lambda function to send APIGW Payload events to a Kafka topic
package main

import (
	"context"
	"encoding/json"
	"fmt"
	ddLambda "github.com/DataDog/datadog-lambda-go"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/pixie79/data-utils/aws"
	"github.com/pixie79/data-utils/kafka"
	"github.com/pixie79/data-utils/types"
	"github.com/pixie79/data-utils/utils"
)

func myHandler(ctx context.Context, event events.APIGatewayProxyRequest) (types.LambdaProxyResponse, error) {
	utils.Logger.Info(fmt.Sprintf("Running Lambda against region: %s", utils.GetEnv("AWS_REGION", "eu-west-1")))

	if utils.LogLevel == "DEBUG" {
		rawEvent, err := json.Marshal(event)
		utils.MaybeDie(err, "unable to parse raw event: %+v")
		utils.Logger.Debug(fmt.Sprintf("raw event %s", rawEvent))
		rawCtx, err := json.Marshal(ctx)
		utils.MaybeDie(err, "unable to parse raw event: %+v")
		utils.Logger.Debug(fmt.Sprintf("raw context %s", rawCtx))
	}

	credentialsKey := utils.GetEnv("KAFKA_CREDENTIALS_KEY", "kafka_credentials_key")
	credentials := aws.FetchCredentials(credentialsKey)
	eventPayload, ctx := aws.ApiGwCreateKafkaEvent(ctx, event, []byte(""))
	kafka.CreateConnectionAndSubmitRecords(ctx, eventPayload, credentials)

	return types.LambdaProxyResponse{Body: "OK", StatusCode: 200}, nil
}

// main is the entry point for the Lambda function
func main() {
	lambda.Start(ddLambda.WrapFunction(myHandler, nil))
}
