import json
import boto3 
from datetime import datetime
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor-analytics')

def lambda_handler(event, context):
    body = json.loads(event['body'])

    item = {
        'id': str(uuid.uuid4()),
        'page': body.get('page', 'unknown'),
        'timestamp': datetime.utcnow().isoformat(),
        'user_agent': event['headers'].get('user-agent', 'unknown'),
        'ip': event['requestContext'].get('http', {}).get('sourceIp', 'unknown')
    }

    table.put_item(Item=item)

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Page view logged'})
    }
