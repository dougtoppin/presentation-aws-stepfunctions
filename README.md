[![GitPitch](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/dougtoppin/presentation-aws-stepfunctions/master?grs=github&t=sky)

# presentation-aws-stepfunctions
The AWS Step Functions service can be used to orchestrate your activities as well as
numerous other functions.

(Click on the above gitpitch slideshow badge to see this presentation rendered correctly)

This is an example of using a Step Function in conjunction with a Lambda function to implement a reminder service.

## Resources

This exercise should have no cost assuming that the resource accesses do not exceed the base limits.
The AWS resources created have no inherent fixed price.
Cost is based on per request usage.
Note this implies that they should not be publicly accessible without protections on unintended accesses.

* CloudFormation stack - no cost [https://aws.amazon.com/cloudformation/pricing/](https://aws.amazon.com/cloudformation/pricing/)
* Step Function - [https://aws.amazon.com/step-functions/pricing/](https://aws.amazon.com/step-functions/pricing/)
* Lambda function - [https://aws.amazon.com/lambda/pricing/](https://aws.amazon.com/lambda/pricing/)
* SNS topic - [https://aws.amazon.com/sns/pricing/](https://aws.amazon.com/sns/pricing/)

## Usage

A single CloudFormation stack is used to create all of the resources needed
for this application.
This is beneficial in that it documents everything required as well as
being able to create and delete all resources with a single command.

Specify an email address for an SNS notification to be sent to when
reminder messages are sent.

```

Create the CloudFormation stack and AWS resources:
    make -e EMAIL=email@example.com create-cf


Create a reminder as a test:
    make run-cf

Delete the CloudFormation stack and all AWS resources:
    make delete-cf

```

To set the STACKNAME environment variable in the Makefile and therefore all resources
include it in the invocation like the following

```
 
make EMAIL=dougtoppin@gmail.com  STACKNAME=remindmetest2 create-cf

make STACKNAME=remindmetest2 run-cf

make STACKNAME=remindmetest2 delete-cf

```



```



## Maintenance

The Makefile *validate* command uses *cloudformation validate* and 
*cfn-lint* to validate the CloudFormation template.
Validation can be helpful in finding errors in the template more quickly
than waiting for CloudFormation to encounter and report them.

Install *cfn-lint* as follows using a virtual environment and then use validate.

```

virtualenv _env
source _env/bin/activate

pip install cfn-lint

make validate

deactivate

```

