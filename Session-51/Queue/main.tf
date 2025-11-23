terraform {
  
  required_version = ">=1.0"
  required_providers {
    aws={
        source = "hashicorp/aws"
        version="~>5.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
  
}

#############################################################
#   DQL
#############################################################
resource "aws_sqs_queue" "dlq" {
    name="my-dead-letter-queue"
    message_retention_seconds = 1209600 #14 days
}

##############################################################
# 2. Main SQS Standard Queue
##############################################################
resource "aws_sqs_queue" "main_queue" {
    name = "my-main-queue"
    visibility_timeout_seconds = 30 # message hidden time after being picked
    delay_seconds = 0
    max_message_size = 262144 # 256 KB
    #### Attach DLQ to main QUEUE ####
    redrive_policy=jsonencode({
        deadLetterTargetArn= aws_sqs_queue.dlq.arn 
        maxReceiveCount= 3 #after 3 failed attempts ---> move to DLQ
    }) 
  
}

#############################################################
# Output
#############################################################

output "main_queue_url"{
    value = aws_sqs_queue.main_queue.url
}

output "main_queue_arn" {
    value = aws_sqs_queue.main_queue.arn
  
}

output "dlq_url"{
    value = aws_sqs_queue.dlq.url
}
output "dlq_arn"{
    value = aws_sqs_queue.dlq.arn
}