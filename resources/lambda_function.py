"""Test basic Lambda function."""
import json
import os
import re


def lambda_handler(event, context):
    """
    Test basic Lambda function.

    Updated: October 5th, 2021 - 19:45PM MYT

    return dict
    """
    # Main action.
    try:
        assert event['headers']['content-type'] == 'application/json'
        assert re.match(r'^[\d]+$', event['queryStringParameters']['code'])
        assert re.match(r'^[\w]+$', json.loads(event['body'])['myname'])
        code = event['queryStringParameters']['code']
        myname = json.loads(event['body'])['myname']
    except Exception as e:
        status_code = 400
        status = 'Bad input.'
    else:
        status_code = 200
        status = (
            'Howdy, {}! '
            'Here\'s your event: {} '
            .format(myname, event)
        )

    # Return response.
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': os.environ['CORS']
        },
        'body': json.dumps({'message': status}, default=str)
    }
