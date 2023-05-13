package main

import (
	"github.com/aws/aws-lambda-go/lambda"
)

// Response is the generic lambda response
type Response struct {
	Message string `json:"message"`
}

func Handler() (Response, error) {
	return Response{
		Message: "Hi from Go!1.2",
	}, nil
}

func main() {
	lambda.Start(Handler)
}
