## AWS Step Functions


[github.com/dougtoppin/presentation-aws-stepfunctions](github.com/dougtoppin/presentation-aws-stepfunctions.git)

---

## Agenda

- What are AWS Step Functions
- Why use it
- Related tools
- Where did it help me
- Syntax
- Examples
- Lessons learned
- Demo
- Links

---
### What are AWS Step Functions

"AWS Step Functions makes it easy to coordinate the components of distributed
applications and microservices using visual workflows. Building applications from individual components
that each perform a discrete function lets you scale and change applications quickly."

---
### Why use it

* step functions are free (resources used are not), note that state transitions do have a cost past a base level
* serverless, no blocked foreground shell script
* orchestrate your Lambda functions and other resources
* up 1,000,000 Step functions can be in effect at once in an account
* a step function can live for up to 1 year
* state transitions and data from an execution are preserved for months for review

+++


---
### Related orchestration tools

note the difference between "automation and orchestration"

- BPM
- Terraform
- Chef
- Puppet
- Ansible


---

### Where did it help me

+++

* no blocked foreground shell

### How might it help you

+++

* orchestrate responses to events (CloudWatch, S3 for example)
* provide your services via the API gateway

---

### Syntax

- Step compose UI is very basic, creates a configuration file that can be json or yaml


+++

state actions are described using a format that can be found at [states-language.net/spec.html](https://states-language.net/spec.html)



+++

What can a State Function do?

* Pass State - don't do anything
* Task State - do something (Lambda for example)
* Choice State - what should I do?
* Wait State - hold up for a bit
* Succeed State - whew, we made it
* Fail State - crap, we blew chunks
* Parallel State - let's work together

+++

Once created, Step function executions can be started using the  AWS console, CLI or API

+++

### CLI

```
  aws stepfunctions start-execution \
    --state-machine-arn "arn:aws:states:us-east-1:${AWSID}:stateMachine:${STACKNAME}" \
    --input '{ "message": "remind me of something", "timestamp": "2019-01-27 09:00:00"}'

```

---

### Examples

* create CloudFormation stack
* reminder service using Lambda
* reminder service using Step/SNS integration

---

#### Invoke CloudFormation functions


---

#### Reminder service using Lambda

* create an SNS topic that will email you
* create a Lambda function that will use the SDK (Python/boto3) to send a notification to the topic
* create a Step function that just uses wait and then runs the Lambda function
* volve that to pass the timestamp or relative time to wait to the Step function

+++

Example: Reminder service

Lambda Python Function
```
import json
import boto3

def lambda_handler(event, context):

    message = {"msg": event['message']}

    # get the notification arn from the parameter store
    ssmclient = boto3.client('ssm')
    
    # get the ssn topic arn to use from the parameter store
    response = ssmclient.get_parameter(Name='notifyme')

    # set up to send to the sns topic
    snsclient = boto3.client('sns')

    # send the notification to the topic
    response = snsclient.publish(
        TargetArn=response['Parameter']['Value'],
        Message=json.dumps({'default': json.dumps(message)}),
        MessageStructure='json'
    )
```

+++

Step Function with SNS integration
```
{
  "Comment": "Use SNS to remind me of something",
  "StartAt": "wait_using_timestamp",
  "States": {

    "wait_using_timestamp": {
      "Type": "Wait",
      "TimestampPath": "$.timestamp",
      "Next": "remindme"
    },
    "remindme": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:xxx:function:remindme",
      "End": true
    }
  }
}

```

+++

Reminder service using SNS integration

+++

cli invocation

Example timestamp, note timezone of Z: 2018-04-24T17:45:00Z

ARN is the arn of the Step Function (pulled from the Parameter Store)

```
aws stepfunctions start-execution --state-machine-arn $ARN --input "{ \"timestamp\": \"$TS\", \"message\":\"$MESSAGE\" }"
```

Example:

```

remindme.sh "remind me of something" "2019-01-27 09:00:00"


```
---

### Lessons learned

+++

know your (account) limits (before they bite you in the butt)

+++

include TimeoutSeconds to avoid stuck machines

+++

Learn to manipulate json input/output

+++

Task states can catch errors and branch

+++

Figure out the workflow that works for you
* json editor and copy paste to designer?
* designer and copy past to json editor?
* test data?

+++

Take time to learn to recognize errors and their causes, find an example that
works and then change things to break it and then debug

+++

You will probably have to think differently about microservices than you generally do

+++

Names matter

Name Lambda functions in a structured manner or else you end up with a boatload of confusing Lambda functions


+++

Think ahead

Plan your architecture

+++

IAM

Anything your Lambda functions do needs to be allowed by their execution role

+++

Don't delay/sleep/wait in Lambda, use Step `wait` and poll status with a Lambda function, Lambda costs and Step does not

+++

Watch your account level metrics for how many and how long your Lambda functions are running

+++

Error reporting by the Step UI when editing is challenging to interpret

```
There is a problem with your ASL definition, please review it and try again
```

+++

Online references/examples can be minimal

+++

Use comments in your Step json to explain what you are intending to do and how, it may not be obvious (months later)

+++

Your Step function will probably require more steps than you think it will

+++

Your first step should probably error check the invocation arguments for things like date in the past or incorrectly formatted date.

+++

No IDE support (but do you need one?), however, reformatting in the designer would be nice

---


### Demo

Screenshots for discussion

* [assets/step-08.png](assets/step-08.png) - creation
* [assets/step-01.png](assets/step-01.png) - execution completed
* [assets/step-02.png](assets/step-02.png) - start execution using cli
* [assets/step-03.png](assets/step-03.png) - history of a function
* [assets/step-04.png](assets/step-04.png) - in progress
* [assets/step-05.png](assets/step-05.png) - in progress, state selected
* [assets/step-06.png](assets/step-06.png) - in progress with execution history
* [assets/step-07.png](assets/step-07.png) - status




---

## Links

* [aws.amazon.com/step-functions/](https://aws.amazon.com/step-functions/)
* [states-language.net/spec.html](https://states-language.net/spec.html)
* [github.com/dougtoppin/presentation-aws-stepfunctions](https://github.com/dougtoppin/presentation-aws-stepfunctions)
* [https://blog.scottlogic.com/2018/06/19/step-functions.html](https://blog.scottlogic.com/2018/06/19/step-functions.html) - step/lambda experiences
