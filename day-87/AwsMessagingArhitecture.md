# AWS Messaging Architecture: SNS, SQS, EventBridge

## Overview

This project demonstrates a scalable messaging architecture using **AWS SNS (Simple Notification Service)**, **SQS (Simple Queue Service)**, and **EventBridge**. The architecture enables decoupled, reliable, and asynchronous communication between services.

Key components:

* **SNS**: Publishes messages/events to multiple subscribers.
* **SQS**: Queues messages for reliable asynchronous processing.
* **EventBridge**: Routes events based on rules to target services (Lambda, SQS, SNS, Step Functions, etc.)

---

## Architecture Flow

```
         ┌───────────┐
         │  Producer │
         └─────┬─────┘
               │
               ▼
          ┌───────────┐
          │    SNS    │
          └───┬───────┘
   ┌───────────┼───────────┐
   │           │           │
   ▼           ▼           ▼
┌───────┐   ┌───────┐   ┌───────────┐
│ SQS A │   │ SQS B │   │ EventBridge│
└───────┘   └───────┘   └─────┬─────┘
                               │
                       ┌─────────────┐
                       │  Lambda /   │
                       │  TargetSvc  │
                       └─────────────┘
```

### Flow Description

1. **Producer publishes events**
   Applications, microservices, or devices generate messages/events and publish them to an SNS topic.

2. **SNS fanout**
   The SNS topic distributes messages to multiple subscribers:

   * **SQS queues** for asynchronous message processing.
   * **EventBridge** for advanced event routing.

3. **SQS queues process messages**

   * **Queue A** and **Queue B** can represent different microservices consuming the same messages.
   * SQS ensures **message durability** and **retry mechanisms**.

4. **EventBridge routing**

   * EventBridge evaluates **event patterns** and routes events to appropriate targets:

     * **Lambda functions** for serverless processing.
     * **Another SNS topic** or **SQS queue**.
     * **Step Functions** for orchestrated workflows.

5. **Consumers process messages**
   Services consuming from SQS or EventBridge targets process events independently, ensuring decoupled and scalable architecture.

---

## AWS Component Configuration

### 1. SNS Topic

* **Name**: `MyApp-Notifications`
* **Type**: Standard
* **Delivery protocols**: SQS, Lambda, HTTP
* **Use case**: Publish all application notifications to subscribers.

### 2. SQS Queues

* **Queue A**

  * Receives messages from SNS.
  * Used for **Service A processing**.
  * Retention period: 4 days
  * Visibility timeout: 30 seconds
* **Queue B**

  * Receives messages from SNS.
  * Used for **Service B processing**.

### 3. EventBridge

* **Event Bus**: `default` or custom
* **Rules**:

  * Example: Forward messages where `eventType=USER_SIGNUP` to a Lambda function for processing.
* **Targets**:

  * Lambda, SQS, SNS, Step Functions

---

## Example Event Flow

```json
{
  "eventType": "ORDER_PLACED",
  "orderId": "12345",
  "customer": {
    "id": "abc",
    "name": "John Doe"
  },
  "timestamp": "2026-02-12T10:00:00Z"
}
```

* **SNS** publishes this message.
* **SQS queues** receive it for asynchronous processing.
* **EventBridge** routes it to a Lambda for real-time analytics.

---

## Benefits

* **Decoupled architecture**: Producers don’t know consumers.
* **Scalable**: SQS allows multiple consumers to process messages concurrently.
* **Reliable**: Guaranteed delivery via SQS and retry mechanisms.
* **Flexible event routing**: EventBridge allows advanced routing based on event patterns.
* **Serverless-friendly**: Easy integration with Lambda and Step Functions.

---

## Deployment Steps

1. **Create SNS topic**

   ```bash
   aws sns create-topic --name MyApp-Notifications
   ```

2. **Create SQS queues**

   ```bash
   aws sqs create-queue --queue-name QueueA
   aws sqs create-queue --queue-name QueueB
   ```

3. **Subscribe SQS queues to SNS**

   ```bash
   aws sns subscribe --topic-arn <SNS_TOPIC_ARN> --protocol sqs --notification-endpoint <SQS_QUEUE_ARN>
   ```

4. **Create EventBridge rule**

   ```bash
   aws events put-rule --name "UserSignUpRule" --event-pattern '{"source": ["myapp"], "detail-type": ["USER_SIGNUP"]}' --state ENABLED
   aws events put-targets --rule UserSignUpRule --targets "Id"="1","Arn"="<LAMBDA_ARN>"
   ```

---

## Monitoring

* **SNS**: Delivery metrics via CloudWatch
* **SQS**: Monitor ApproximateNumberOfMessages, AgeOfOldestMessage
* **EventBridge**: Check event delivery success metrics
* **CloudWatch Alarms**: Configure for failures and delays

