# Makefile

# The name of the CloudFormation stack and root name of the resources created
STACKNAME=remindmetest

# The CloudFormation template that manages the AWS resources
TEMPLATE=remindme.yaml

# when creating, set this to the email address to receive notifications
# Example make EMAIL=myemail@domain.com create-cf
EMAIL=""

# validate the CloudFormation template (pip install cfn-lint)
validate:

	@echo validate using cloudformation
	aws cloudformation validate-template --template-body file://${TEMPLATE}

	@echo validate using cfn-lint
	cfn-lint remindme.yaml

# create the CloudFormation stack and AWS resources
create-cf: validate

	aws cloudformation create-stack --stack-name ${STACKNAME} --template-body file://${TEMPLATE} --capabilities CAPABILITY_IAM --parameters ParameterKey=EMAIL,ParameterValue=${EMAIL}

	# delay exiting until the create is complete, this is not necessary and only for demonstration
	aws cloudformation wait stack-create-complete --stack-name ${STACKNAME}

# delete the CloudFormation stack and resources
delete-cf:

	aws cloudformation delete-stack --stack-name ${STACKNAME}

	# delay exiting until the delete is complete, this is not necessary and only for demonstration
	aws cloudformation wait stack-delete-complete --stack-name ${STACKNAME}

# run a test by creating a reminder, note that this is in the past and should therefore immediately trigger
run-cf:

	# get the AWS account id in effect
	$(eval AWSID = $(shell aws sts get-caller-identity --output text --query 'Account'))

	# create the reminder
	aws stepfunctions start-execution \
		--state-machine-arn "arn:aws:states:us-east-1:${AWSID}:stateMachine:${STACKNAME}" \
		--input '{ "message": "remind me of something", "timestamp": "2019-01-27 09:00:00"}'

test-cf:

	# get and echo the AWS account id in effect
	$(eval AWSID = $(shell aws sts get-caller-identity --output text --query 'Account'))

	echo ${AWSID}
	echo ${EMAIL}
