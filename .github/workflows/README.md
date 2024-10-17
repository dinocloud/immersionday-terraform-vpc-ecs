# Github Actions

Do not forget to add the following github repository secrets so that the terraform plan works:

* APPROVERS = user1,user2,usern. List of the responsible Github users who will approve the terraform plan before deployment.
* REGION = AWS Region. I.o: us-east-1
* ROLE_ARN_DEVELOP = AWS Develop IAM Role ARN with enough permissions to deploy into AWS.
* ROLE_ARN_PRODUCTION= AWS Production IAM Role ARN with enough permissions to deploy into AWS.
* ROLE_ARN_STAGING= AWS Staging IAM Role ARN with enough permissions to deploy into AWS.
* SLACK_BOT_TOKEN = token of the Slack bot necessary to send Slack notifications on workflow updates.
* SLACK_CHANNEL_ID = slack channel id where the notifications will be sent.
