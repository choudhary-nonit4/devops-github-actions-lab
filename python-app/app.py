def handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from Lambda Docker! I am running in a container built from a Dockerfile."
    }