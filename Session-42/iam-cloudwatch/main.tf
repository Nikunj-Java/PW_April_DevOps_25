resource "aws_iam_user" "cloudwatch_user" {
    name = "cloudwatch-access-user"
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"
    actions = ["logs:*","s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_policy" {
    name="cloudwatch-policy"
    description = "Access Logs cloudwatch"
    policy=data.aws_iam_policy_document.cloudwatch.json
  
}
resource "aws_iam_user_policy_attachment" "attach" {
    user = aws_iam_user.cloudwatch_user.name
    policy_arn = aws_iam_policy.cloudwatch_policy.arn
  
}

resource "aws_s3_bucket" "alb_logs" {
    bucket = var.bucket_name
    force_destroy = true
}
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.alb_logs.id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false 
}

resource "aws_s3_bucket_policy" "policy_read" {
    bucket = aws_s3_bucket.alb_logs.id
    policy = jsonencode({

   
    "Version"="2012-10-17",
    "Statement"=[
        {
            "Sid"="AWSLogsDeliveryWrite"
            "Effect"="Allow",
            "Principal"={
                Service="logdelivery.elasticloadbalancing.amazonaws.com"
            }
            "Action"="s3:PutObject",
            "Resource"="${aws_s3_bucket.alb_logs.arn}/*"
            "Condition"={
                StringEquals={
                    "s3:x-amz-acl"="bucket-owner-full-control"
                }
            }
        },
        {
            "Sid"="AWSLogsDeliveryACLCheck"
            "Effect"="Allow"
            "Principal"={
                Service="logdelivery.elasticloadbalancing.amazonaws.com"
            }
            "Action"="s3:GetBucketAcl",
            "Resource"="${aws_s3_bucket.alb_logs.arn}"
        }
    ]
  })
  
}