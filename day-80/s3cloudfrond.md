# Host Static Website on Amazon S3 + CloudFront

## Overview

* **Amazon S3** stores static website files
* **Amazon CloudFront** distributes content globally using edge locations
* **HTTPS** is enabled via CloudFront
* Improves **performance, security, and availability**

## Architecture Flow Diagram (Text)

```
User Browser
     |
     | HTTPS Request
     v
CloudFront (CDN)
     |
     | Cache Miss (First Request)
     v
Amazon S3 Bucket (Static Website Files)
     |
     | HTML / CSS / JS
     v
CloudFront Cache
     |
     v
User Browser
```

---

## Prerequisites

* AWS Account
* Basic knowledge of AWS Console
* Static website files (index.html, CSS, JS)
* Optional: Custom domain (Route 53)

---

## Step 1: Create an S3 Bucket

1. Open **AWS S3 Console**
2. Click **Create bucket**
3. Enter a unique bucket name (e.g., `my-static-site-bucket`)
4. Select region
5. Uncheck **Block all public access**
6. Acknowledge public access warning
7. Create bucket

---

## Step 2: Upload Static Website Files

1. Open the bucket
2. Click **Upload**
3. Upload:

   * `index.html`
   * CSS files
   * JavaScript files
   * Images (if any)
4. Click **Upload**

---

## Step 3: Enable Static Website Hosting

1. Go to **Bucket → Properties**
2. Scroll to **Static website hosting**
3. Enable it
4. Set:

   * Index document: `index.html`
   * Error document (optional): `error.html`
5. Save changes

---

## Step 4: Update Bucket Policy for Public Access

Go to **Permissions → Bucket Policy** and add:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-static-site-bucket/*"
    }
  ]
}
```

Replace `my-static-site-bucket` with your bucket name.

---

## Step 5: Create CloudFront Distribution

1. Open **CloudFront Console**
2. Click **Create distribution**
3. Set **Origin domain** → Select S3 bucket
4. Origin access:

   * Public bucket OR
   * Use OAC (recommended for production)
5. Viewer protocol policy:

   * Redirect HTTP to HTTPS
6. Default root object:

   * `index.html`
7. Create distribution

---

## Step 6: Access Website via CloudFront

* Copy **CloudFront Distribution Domain Name**

  ```
  dxxxxx.cloudfront.net
  ```
* Open it in browser
* Your static site is now live 🎉

---

## Optional: Add Custom Domain (Route 53)

1. Request SSL certificate using **AWS Certificate Manager**
2. Add custom domain in CloudFront
3. Update Route 53:

   * Create **A record**
   * Alias → CloudFront distribution

---

## Benefits of S3 + CloudFront

* Global content delivery
* HTTPS support
* High availability
* Low cost
* Scales automatically

---

## Common Issues


