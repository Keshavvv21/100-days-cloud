# 🚀 Deploy AWS Lambda + API Gateway (Step-by-Step README)

This guide explains how to deploy an **AWS Lambda function** and expose it securely using **Amazon API Gateway**. It includes prerequisites, step-by-step instructions, examples, and best practices.

---

## 📌 Architecture Overview

```
Client (Browser / App / Curl)
        |
        v
Amazon API Gateway (REST / HTTP API)
        |
        v
AWS Lambda Function
        |
        v
(Optional) DynamoDB / S3 / Other AWS Services
```

---

## 🧰 Prerequisites

Before you start, ensure you have:

* ✅ AWS Account
* ✅ AWS CLI installed and configured

  ```bash
  aws configure
  ```
* ✅ IAM permissions for:

  * Lambda
  * API Gateway
  * IAM Roles
* ✅ Node.js / Python installed (for examples)

---

## 🧪 Example Use Case

We will deploy a **Hello World API**:

* **Endpoint**: `GET /hello`
* **Response**:

```json
{
  "message": "Hello from AWS Lambda!"
}
```

---

## 🧱 Step 1: Create Lambda Function

### Option A: Using AWS Console

1. Go to **AWS Console → Lambda → Create function**
2. Choose **Author from scratch**
3. Configure:

   * Function name: `hello-lambda`
   * Runtime: `Node.js 18.x` (or Python 3.10)
   * Execution role: Create a new role with basic Lambda permissions
4. Click **Create function**

### Sample Lambda Code (Node.js)

```js
export const handler = async (event) => {
  return {
    statusCode: 200,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ message: "Hello from AWS Lambda!" })
  };
};
```

Click **Deploy**.

---

## 🧱 Step 2: Test Lambda Function

1. Click **Test**
2. Create a test event (default is fine)
3. Verify response:

```json
{
  "statusCode": 200,
  "body": "{\"message\":\"Hello from AWS Lambda!\"}"
}
```

---

## 🌐 Step 3: Create API Gateway

### Option A: HTTP API (Recommended)

1. Go to **API Gateway → Create API**
2. Select **HTTP API** → Build
3. Click **Add integration** → Lambda
4. Select `hello-lambda`
5. Configure route:

   * Method: `GET`
   * Path: `/hello`
6. Enable **Auto-deploy**
7. Create API

---

## 🔗 Step 4: Get API Endpoint

After creation, note the **Invoke URL**:

```
https://abc123.execute-api.us-east-1.amazonaws.com/hello
```

Test it in browser or using curl:

```bash
curl https://abc123.execute-api.us-east-1.amazonaws.com/hello
```

Response:

```json
{
  "message": "Hello from AWS Lambda!"
}
```

---

## 🔐 Step 5: (Optional) Enable CORS

If calling from frontend (React / Web App):

1. API Gateway → CORS
2. Allow:

   * Origin: `*` (or specific domain)
   * Methods: `GET`
3. Save & Deploy

---

## 🧩 Step 6: IAM Permissions (Behind the Scenes)

API Gateway automatically creates permission:

```text
apigateway.amazonaws.com → invoke Lambda
```

If manual, Lambda permission example:

```bash
aws lambda add-permission \
  --function-name hello-lambda \
  --statement-id apigw \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com
```

---

## ⚙️ Deployment Using AWS CLI (Optional)

### Create Lambda

```bash
zip function.zip index.js
aws lambda create-function \
  --function-name hello-lambda \
  --runtime nodejs18.x \
  --handler index.handler \
  --zip-file fileb://function.zip \
  --role arn:aws:iam::<ACCOUNT_ID>:role/lambda-role
```

---

## 📦 Production Best Practices

* ✅ Use **HTTP API** instead of REST API (lower cost)
* ✅ Enable **CloudWatch Logs**
* ✅ Add **Lambda timeout & memory tuning**
* ✅ Use **Environment Variables**
* ✅ Secure APIs using:

  * IAM auth
  * Lambda Authorizers
  * JWT / Cognito
* ✅ Use **Terraform / SAM / CDK** for infra-as-code

---

## 🛠️ Common Issues & Fixes

| Issue         | Fix                        |
| ------------- | -------------------------- |
| 403 Forbidden | Check Lambda permissions   |
| 500 Error     | Check CloudWatch logs      |
| CORS error    | Enable CORS in API Gateway |
| Timeout       | Increase Lambda timeout    |

---

## 📚 Useful Commands

```bash
aws lambda list-functions
aws apigatewayv2 get-apis
aws logs tail /aws/lambda/hello-lambda --follow
```

---

## 🧾 Summary

✔ Lambda handles business logic
✔ API Gateway exposes secure HTTP endpoints
✔ Scalable, serverless, pay-per-use

This setup is ideal for:

* Microservices
* Backend for frontend (BFF)
* Event-drive
