import sys
import time
import logging


# convert a local time date time string into a UTC date time string
# step functions require a UTC date


# Input example: '2018-04-27 05:04:00'

# example request payload {"timestamp": "2019-01-19 09:00:00"}
#       response content: {"timestamp": "2019-01-19T09:00:00Z"}


def lambda_handler(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    logger.info('convdate:start:{}'.format(event))

    outtime = event['timestamp'] + ""

    # replace the incoming timestamp value with the outgoing reformatted timestamp
    event['timestamp'] = time.strftime("%Y-%m-%dT%H:%M:%SZ",
                                       time.gmtime(time.mktime(time.strptime(outtime, "%Y-%m-%d %H:%M:%S"))))

    logger.info('convdate:finish:{}'.format(event))

    return event
