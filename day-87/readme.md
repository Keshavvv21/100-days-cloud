# Systems Manager (SSM) & Parameter Store

---

# AWS Systems Manager (SSM) & Parameter Store

## 📌 Overview

This project/document explains how we use **AWS Systems Manager (SSM)** and **AWS Parameter Store** to securely manage configuration, secrets, and operational control of our infrastructure and applications.

SSM helps manage EC2 instances and servers at scale, while Parameter Store securely stores configuration values such as API keys, database credentials, environment variables, and service endpoints.

---

## 🚀 Why Use SSM & Parameter Store?

### ✅ Centralized Configuration Management

Store application configuration in a single secure location.

### ✅ Secure Secret Storage

Encrypt sensitive values using AWS KMS.

### ✅ No Hardcoded Secrets

Avoid storing credentials in code, `.env` files, or Docker images.

### ✅ Fine-Grained Access Control

Use IAM policies to control who/what can access parameters.

### ✅ Easy Integration

Works seamlessly with:

* EC2
* ECS
* EKS
* Lambda
* Docker containers
* CI/CD pipelines

---

# 🛠 AWS Systems Manager (SSM)

AWS SSM provides:

### 1️⃣ Session Manager

Secure shell access to EC2 instances without:

* Opening port 22
* Using SSH keys
* Managing bastion hosts

```bash
aws ssm start-session --target <instance-id>
```

---

### 2️⃣ Run Command

Execute commands remotely on EC2 instances.

```bash
aws ssm send-command \
  --instance-ids "i-1234567890abcdef0" \
  --document-name "AWS-RunShellScript" \
  --parameters commands="docker ps"
```

---

### 3️⃣ Patch Manager

Automate OS patching across instances.

---

# 🔐 AWS Parameter Store

Parameter Store is part of SSM and is used to store:

* Database URLs
* API keys
* JWT secrets
* Application configs
* Feature flags
* Environment variables

---

## 📂 Parameter Types

| Type         | Description               |
| ------------ | ------------------------- |
| String       | Plain text value          |
| StringList   | Comma-separated values    |
| SecureString | Encrypted value using KMS |

---

## 🔑 Creating a Parameter

### Create Secure Parameter

```bash
aws ssm put-parameter \
  --name "/prod/db/password" \
  --value "MySecurePassword" \
  --type "SecureString"
```

---

## 📥 Fetching a Parameter

```bash
aws ssm get-parameter \
  --name "/prod/db/password" \
  --with-decryption
```

---

## 🐳 Using in Docker / Node.js App

### Example (Node.js)

```javascript
import AWS from "aws-sdk";

const ssm = new AWS.SSM({ region: "ap-south-1" });

async function getParameter(name) {
  const response = await ssm.getParameter({
    Name: name,
    WithDecryption: true,
  }).promise();

  return response.Parameter.Value;
}

export default getParameter;
```

---

## 🏗 Recommended Parameter Naming Convention

Use structured paths:

```
/environment/service/component/key
```

Example:

```
/prod/aksha/api/db_url
/prod/aksha/api/jwt_secret
/dev/aksha/frontend/api_base_url
```

---

# 🔐 IAM Policy Example

Allow access to specific parameters:

```json
{
  "Effect": "Allow",
  "Action": [
    "ssm:GetParameter",
    "ssm:GetParameters"
  ],
  "Resource": "arn:aws:ssm:ap-south-1:123456789012:parameter/prod/aksha/*"
}
```

---

# 🔄 Best Practices

* ✅ Always use `SecureString` for secrets
* ✅ Restrict access via IAM roles
* ✅ Avoid using root user
* ✅ Use parameter path hierarchy
* ✅ Rotate secrets regularly
* ✅ Use KMS-managed encryption

---

# 📊 When to Use Parameter Store vs Secrets Manager

| Feature         | Parameter Store        | Secrets Manager           |
| --------------- | ---------------------- | ------------------------- |
| Free Tier       | Yes                    | Limited                   |
| Secret Rotation | Manual                 | Automatic                 |
| Cost            | Low                    | Higher                    |
| Best For        | Config + Small Secrets | High-security credentials |

---

# 🏢 Architecture Example

```
Application (EC2 / ECS / Lambda)
        ↓
IAM Role
        ↓
AWS SSM Parameter Store
        ↓
KMS (Encryption)
```

---

# 🧪 Use Cases in Our Project

* Store DB credentials
* Store JWT secrets
* Store ML model paths
* Store API keys
* Store environment-specific configs
* Remote debugging using Session Manager

---

# 📚 References

* AWS SSM Documentation
* AWS Parameter Store Documentation
* AWS IAM Best Practices

---

# 🏁 Conclusion

AWS Systems Manager and Parameter Store provide:

* Secure secret management
* Centralized configuration
* Operational control without SSH
* Better DevOps practices
* Improved security posture

They eliminate hardcoded secrets and simplify infrastructure management at scale.

