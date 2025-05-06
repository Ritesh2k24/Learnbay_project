import json
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('contact-submissions')

def lambda_handler(event, context):
    data = json.loads(event['body'])
    
    item = {
        'id': str(uuid.uuid4()),
        'name': data.get('name'),
        'email': data.get('email'),
        'message': data.get('message'),
        'timestamp': datetime.utcnow().isoformat()
    }
    
    table.put_item(Item=item)
    
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Submission received'})
    }
