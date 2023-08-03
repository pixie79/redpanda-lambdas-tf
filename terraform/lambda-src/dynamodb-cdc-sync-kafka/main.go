// Copyright Pixie79
// All Rights Reserved
// Distributed under the terms of the MIT License.

// Package main - an AWS Lambda function to send DynamoDB Stream events to a Kafka topic
package main

import (
	"context"
	"encoding/json"
	"fmt"
	ddLambda "github.com/DataDog/datadog-lambda-go" // Datadog Lambda wrapper
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda" // AWS Lambda wrapper
	"github.com/pixie79/data-utils/aws"
	"github.com/pixie79/data-utils/kafka"
	"github.com/pixie79/data-utils/utils" // Utils functions
)

// main is the entry point for the Lambda function
func main() {
	lambda.Start(ddLambda.WrapFunction(myHandler, nil))
}

// myHandler is the Lambda function handler
func myHandler(ctx context.Context, event events.DynamoDBEvent) {
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
	convertedEvent := aws.MarshalDynamoDBEventToLocal(event)
	eventPayload, ctx := aws.DynamoDbCreateKafkaEvent(ctx, convertedEvent, []byte(""))
	kafka.CreateConnectionAndSubmitRecords(ctx, eventPayload, credentials)
}
