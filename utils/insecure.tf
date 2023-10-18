 resource "aws_athena_database" "bad_example" {
   name   = "database_name"
   bucket = aws_s3_bucket.hoge.bucket
 }

 resource "aws_athena_workgroup" "bad_example" {
   name = "example"

   configuration {
     enforce_workgroup_configuration    = true
     publish_cloudwatch_metrics_enabled = true

     result_configuration {
       output_location = "s3://${aws_s3_bucket.example.bucket}/output/"
     }
   }
 }

  resource "aws_apigatewayv2_stage" "bad_example" {
   api_id = aws_apigatewayv2_api.example.id
   name   = "example-stage"
 }

 resource "aws_apigatewayv2_stage" "bad_example" {
   deployment_id = aws_api_gateway_deployment.example.id
   rest_api_id   = aws_api_gateway_rest_api.example.id
   stage_name    = "example"
 }

 resource "aws_apigatewayv2_stage" "good_example" {
   api_id = aws_apigatewayv2_api.example.id
   name   = "example-stage"

   access_log_settings {
    destination_arn = "arn:aws:logs:region:0123456789:log-group:access_logging"
    format          = "json"
   }
 }

 resource "aws_api_gateway_stage" "good_example" {
   deployment_id = aws_api_gateway_deployment.example.id
   rest_api_id   = aws_api_gateway_rest_api.example.id
   stage_name    = "example"

   access_log_settings {
     destination_arn = "arn:aws:logs:region:0123456789:log-group:access_logging"
     format          = "json"
   }
 }


