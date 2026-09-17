import json
import os
import boto3

ec2 = boto3.client("ec2")
sns = boto3.client("sns")

SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")


def lambda_handler(event, context):

    print("Received event:")
    print(json.dumps(event))

    detail = event.get("detail", {})
    instance_id = detail.get("instance-id")
    state = detail.get("state")

    if not instance_id:
        print("No instance ID found")
        return {
            "statusCode": 400,
            "body": "No instance ID found"
        }

    if state == "stopped":
        print(f"Starting stopped instance: {instance_id}")

        ec2.start_instances(
            InstanceIds=[instance_id]
        )

        message = (
            f"Auto-healing action performed. "
            f"EC2 instance {instance_id} was stopped "
            f"and a start action was triggered."
        )

        if SNS_TOPIC_ARN:
            sns.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject="EC2 Auto-Healing Alert",
                Message=message
            )

        return {
            "statusCode": 200,
            "body": message
        }

    if state == "terminated":
        message = (
            f"EC2 instance {instance_id} was terminated. "
            f"Automatic restart is not possible."
        )

        print(message)

        if SNS_TOPIC_ARN:
            sns.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject="EC2 Termination Alert",
                Message=message
            )

        return {
            "statusCode": 200,
            "body": message
        }

    return {
        "statusCode": 200,
        "body": f"No remediation required for state: {state}"
    }
