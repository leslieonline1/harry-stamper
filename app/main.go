package main

import (
	"os"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
)

var db = dynamodb.New(session.New(), aws.NewConfig().WithRegion(os.Getenv("AWS_REGION")))

func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	err := putItem()
	if err != nil {
		return events.APIGatewayProxyResponse{Body: "Error writing timestamp to the database", StatusCode: 500}, nil
	} else {
		return events.APIGatewayProxyResponse{StatusCode: 200}, nil
	}

}

func putItem() error {
	input := &dynamodb.PutItemInput{
		TableName: aws.String("harryStamper"),
		Item: map[string]*dynamodb.AttributeValue{
			"Timestamp": {
				S: aws.String(time.Now().UTC().Format(time.RFC1123)),
			},
		},
	}

	_, err := db.PutItem(input)
	return err
}

func main() {
	lambda.Start(Handler)
}
