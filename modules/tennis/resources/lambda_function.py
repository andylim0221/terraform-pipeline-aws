"""Play tennis in S3."""
import json
import os
import time
import boto3


def lambda_handler(event, context):
    """
    Play tennis in S3.

    return dict
    """
    # Main action.
    if os.environ['ENABLED'] == 'true':

        time.sleep(int(os.environ['DELAY']))

        if event['bucket'] == os.environ['BUCKET1']:
            bucket_src = os.environ['BUCKET1']
            bucket_dest = os.environ['BUCKET2']
        else:
            bucket_src = os.environ['BUCKET2']
            bucket_dest = os.environ['BUCKET1']

        s3 = boto3.resource('s3')
        copy_source = {
            'Bucket': bucket_src,
            'Key': event['key']
        }
        s3.meta.client.copy(copy_source, bucket_dest, event['key'])

        client = boto3.client('s3')
        response = client.delete_object(
            Bucket=bucket_src,
            Key=event['key']
        )

        # Log and return response.
        status = f"Moved {event['key']} from {bucket_src} to {bucket_dest}."
        print(status)
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'message': status}, default=str)
        }
