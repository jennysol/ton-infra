resource "aws_elastic_beanstalk_application" "application" {
  name        = local.project
}

resource "aws_elastic_beanstalk_environment" "environment" {
  name                = "${local.project}-environment"
  application         = aws_elastic_beanstalk_application.application.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.6.8 running Node.js 22"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "5000"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "production"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DYNAMODB_ENDPOINT"
    value     = "https://dynamodb.us-east-1.amazonaws.com"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JWT_SECRET"
    value     = "58fab6f9bc3c81f7563c2d8d063a66cf"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SALT_ROUNDS"
    value     = "12"
  }
}
