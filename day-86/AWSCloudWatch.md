# AWS CloudWatch Setup Guide

This document outlines the steps to create and configure **CloudWatch Logs, Metrics, and Alarms** for monitoring your AWS resources and applications.

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [CloudWatch Logs](#cloudwatch-logs)
4. [CloudWatch Metrics](#cloudwatch-metrics)
5. [CloudWatch Alarms](#cloudwatch-alarms)
6. [Best Practices](#best-practices)
7. [References](#references)

---

## Overview

AWS **CloudWatch** is a monitoring and observability service that provides:

* **Logs:** Store and monitor log files from AWS resources and applications.
* **Metrics:** Measure and track performance or operational data.
* **Alarms:** Notify or trigger actions based on thresholds or anomalies.

This guide helps you set up logs, metrics, and alarms in a structured way for monitoring your environment.

---

## Prerequisites

Before setting up CloudWatch, ensure:

* AWS CLI is installed and configured (`aws configure`).
* IAM role or user has permissions for CloudWatch:

  * `logs:CreateLogGroup`
  * `logs:CreateLogStream`
  * `logs:PutLogEvents`
  * `cloudwatch:PutMetricData`
  * `cloudwatch:PutMetricAlarm`

---

## CloudWatch Logs

CloudWatch Logs collect and monitor log data from your AWS resources.

### Steps to Create Log Group

```bash
aws logs create-log-group --log-group-name MyAppLogGroup
```

### Steps to Create Log Stream

```bash
aws logs create-log-stream \
    --log-group-name MyAppLogGroup \
    --log-stream-name MyAppLogStream
```

### Push Logs to CloudWatch

```bash
aws logs put-log-events \
    --log-group-name MyAppLogGroup \
    --log-stream-name MyAppLogStream \
    --log-events timestamp=$(date +%s%3N),message="Application started"
```

---

## CloudWatch Metrics

Metrics allow you to track performance and operational data.

### Publish Custom Metric

```bash
aws cloudwatch put-metric-data \
    --namespace "MyApp" \
    --metric-name "CPUUsage" \
    --value 75 \
    --unit Percent
```

### View Metrics in Console

1. Go to **CloudWatch** > **Metrics**.
2. Select the appropriate **Namespace**.
3. Visualize the metric using **Graphs**.

---

## CloudWatch Alarms

Alarms help monitor your metrics and trigger actions.

### Steps to Create Alarm via CLI

```bash
aws cloudwatch put-metric-alarm \
    --alarm-name "HighCPUAlarm" \
    --metric-name "CPUUsage" \
    --namespace "MyApp" \
    --statistic "Average" \
    --period 60 \
    --threshold 80 \
    --comparison-operator "GreaterThanThreshold" \
    --evaluation-periods 1 \
    --alarm-actions arn:aws:sns:us-east-1:123456789012:MySNSTopic \
    --unit Percent
```

### Alarm Actions

* Send notification via **SNS**.
* Auto-scale EC2 instances.
* Trigger Lambda function for automation.

---

## Best Practices

* Use **separate log groups** for different applications or environments.
* Set **retention policies** to save costs:

```bash
aws logs put-retention-policy --log-group-name MyAppLogGroup --retention-in-days 30
```

* Use **custom namespaces** for easier metric organization.
* Set **meaningful thresholds** for alarms to avoid false alerts.
* Enable **CloudWatch Contributor Insights** for advanced log analysis.

---

## References

* [AWS CloudWatch Documentation](https://docs.aws.amazon.com/cloudwatch/)
* [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)
* [CloudWatch Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)
* [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)


