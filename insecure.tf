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

