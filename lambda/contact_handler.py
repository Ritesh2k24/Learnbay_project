import json
import boto3
import uuid

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("contact-submissions")

def lambda_handler(event, context):
    try:
        data = json.loads(event["body"])

        table.put_item(
            Item={
                "id": str(uuid.uuid4()),
                "name": data["name"],
                "email": data["email"],
                "message": data["message"]
            }
        )

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json"
            },
            "body": json.dumps({"message": "Submission received"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json"
            },
            "body": json.dumps({"error": str(e)})
        }
