
# **README.md – S3 Lifecycle, Glacier, Versioning**


# Day XX: Amazon S3 – Lifecycle Rules, Glacier, and Versioning

This guide explains three essential S3 features that improve durability, reduce storage costs, and protect data:

- **S3 Versioning**
- **S3 Lifecycle Policies**
- **S3 Glacier Storage Classes**

These are widely used in real-world architectures for backup, compliance, and long-term archival.

---

# 📘 Overview Flow Diagram

Below is a clear ASCII flow diagram representing **how objects move through S3 storage classes over time** using lifecycle rules, versioning, and Glacier transitions.

```

```
                  ┌────────────────────┐
                  │ Upload Object to   │
                  │   S3 Standard      │
                  └─────────┬──────────┘
                            │
                            │ After 30 Days
                            ▼
              ┌────────────────────────────┐
              │ Transition to S3 Standard-IA│
              └─────────┬──────────────────┘
                        │
                        │ After 90 Days
                        ▼
            ┌────────────────────────────────┐
            │ Transition to S3 Glacier        │
            └─────────┬──────────────────────┘
                      │
                      │ After 365 Days
                      ▼
      ┌────────────────────────────────────────┐
      │ Transition to S3 Glacier Deep Archive  │
      └─────────┬──────────────────────────────┘
                │
                │ Retain for 7 Years
                ▼
      ┌────────────────────────────────────────┐
      │       Permanently Delete Object        │
      └────────────────────────────────────────┘
```

```

### Versioning Flow (if enabled)

```

```
               ┌─────────────────────┐
               │   New Version of    │
               │   Object Uploaded   │
               └──────────┬──────────┘
                          │
                          ▼
      ┌───────────────────────────────────────┐
      │ Old Version Becomes "Noncurrent"      │
      └──────────┬────────────────────────────┘
                 │
                 │ Lifecycle Rule After 30 Days
                 ▼
      ┌───────────────────────────────────────┐
      │ Noncurrent Versions Deleted or Moved  │
      │     to Glacier to Save Cost           │
      └───────────────────────────────────────┘
```

````

---

# 🗂️ 1. S3 Versioning

S3 Versioning keeps *all* versions of an object, protecting you from:

- Accidental deletions  
- Overwrites  
- Application bugs  

### 🔧 Enable Versioning (AWS Console)

1. Open your S3 bucket  
2. Go to **Properties**  
3. Enable **Bucket Versioning**

### 🔧 Enable via CLI

```bash
aws s3api put-bucket-versioning \
  --bucket my-bucket \
  --versioning-configuration Status=Enabled
````

### 💡 Notes

* Deleting an object adds a **delete marker**
* You are billed for *all versions*
* Use Lifecycle rules to clean older versions

---

# 🔁 2. S3 Lifecycle Management

S3 Lifecycle rules automate operations on objects based on their age:

| Action                | Description               |
| --------------------- | ------------------------- |
| Transition            | Move data to cheaper tier |
| Expiration            | Delete objects            |
| Noncurrent Expiration | Delete older versions     |
| Multipart Cleanup     | Clear partial uploads     |

---

## ✔️ Example Lifecycle Rule

Move data across tiers automatically:

* After 30 days → move to **Standard-IA**
* After 90 days → move to **Glacier**
* After 365 days → move to **Glacier Deep Archive**
* After 7 years → delete

### JSON Rule Example

```json
{
  "Rules": [
    {
      "ID": "GlacierTransition",
      "Status": "Enabled",
      "Filter": {},
      "Transitions": [
        { "Days": 30, "StorageClass": "STANDARD_IA" },
        { "Days": 90, "StorageClass": "GLACIER" },
        { "Days": 365, "StorageClass": "DEEP_ARCHIVE" }
      ],
      "Expiration": {
        "Days": 2555
      }
    }
  ]
}
```

Apply with AWS CLI:

```bash
aws s3api put-bucket-lifecycle-configuration \
  --bucket my-bucket \
  --lifecycle-configuration file://lifecycle.json
```

---

# ❄️ 3. Glacier & Deep Archive Overview

S3 Glacier tiers provide the **lowest-cost storage** for rarely accessed data.

### Storage Classes Comparison

| Class                      | Retrieval Time       | Use Case                      |
| -------------------------- | -------------------- | ----------------------------- |
| Glacier Instant Retrieval  | milliseconds-seconds | Backups with rare access      |
| Glacier Flexible Retrieval | minutes-hours        | Low cost archives             |
| Deep Archive               | 12–48 hrs            | Compliance, 7+ year retention |

### Why Glacier?

* 80–95% cheaper than S3 Standard
* Great for backups, logs, financial/legal records
* Works perfectly with lifecycle rules

---

# 🔄 Versioning + Lifecycle (Best Practice)

When versioning is enabled, you accumulate **noncurrent** (old) versions.

To save cost, add rules like:

```json
{
  "Rules": [
    {
      "ID": "NonCurrentCleanup",
      "Status": "Enabled",
      "Filter": {},
      "NoncurrentVersionTransition": {
        "NoncurrentDays": 30,
        "StorageClass": "GLACIER"
      },
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 90
      }
    }
  ]
}
```

This ensures:

* Past versions move to Glacier
* Very old versions get removed

---

# 🎯 Key Takeaways

| Feature             | Purpose                                     |
| ------------------- | ------------------------------------------- |
| **Versioning**      | Protects from accidental deletion/overwrite |
| **Lifecycle rules** | Automates data movement + cleanup           |
| **Glacier**         | Ultra-cheap archival layer                  |

Together these create a **fully automated, durable, low-cost S3 architecture**.

---

# 📌 Use Cases

* Log archival
* Enterprise backup systems
* Compliance (HIPAA, PCI, financial)
* Medical/legal retention (7–10 years)
* Disaster recovery

---


```
```
