# DevOps AWS Infrastructure Assignment

A production-grade, cost-optimized, and modular AWS environment provisioned with Terraform, including secure networking, ECS, RDS, messaging, monitoring, and best practices.

**Author:** Stefan Claassen
**Date:** June 2025

---

## Table of Contents

* [Requirements](#requirements)
* [Repository Structure](#repository-structure)
* [Implemented Features](#implemented-features)
* [Further Improvements (Not Implemented)](#further-improvements-not-implemented)
* [Setup Instructions](#setup-instructions)
* [Overview](#overview)
* [Architecture Diagram](#architecture-diagram)
* [Rationale](#rationale)
* [Modules](#modules)
* [Monitoring](#monitoring)
* [Cost Optimization](#cost-optimization)
* [Usage](#usage)
* [Health Check Script](#health-check-script)
* [AWS IAM Role Requirements for Pipeline](#aws-iam-role-requirements-for-pipeline)
* [GitHub Environments & Pipeline Secrets](#github-environments--pipeline-secrets)
* [Support](#support)

---

## Requirements

* **Terraform** v1.5 or later
* **AWS Account** with permissions to provision resources
* **AWS CLI** configured OR environment variables for `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`
* **Python 3.x** (for health check script)
* (Optional) **GitHub Actions** or CI/CD runner if testing pipeline

---

## Repository Structure

```
/modules
   /network
   /ecs
   /rds
   /dynamodb
   /messaging
   /monitoring
   /iam
main.tf
variables.tf
outputs.tf
README.md
scripts/health_check.py
architecture-diagram.svg
.github/workflows/terraform.yml
.github/workflows/terraform_destroy.yml
.gitignore

```

---

## Implemented Features

* Modular Terraform configuration (reusable modules)
* Secure VPC with public/private subnets
* ECS Fargate service running [`hashicorp/http-echo`](https://hub.docker.com/r/hashicorp/http-echo)
* RDS PostgreSQL database in private subnet
* DynamoDB table for sessions/metadata
* SQS queue and SNS topic for messaging
* CloudWatch logs and alarms for monitoring (RDS, SQS, ECS)
* IAM roles and policies for least-privilege access
* Resource naming conventions & cost-tracking tags
* Health check script to verify service availability
* Cost optimization strategies & trade-offs
* GitHub Actions pipeline for deployment/teardown
* Documentation and setup instructions
* Architecture diagram

---

## Further Improvements (Not Implemented)

* Use AWS Secrets Manager for sensitive data
* Add VPC endpoints for SQS, SNS, DynamoDB
* Enable CloudWatch Container Insights for ECS
* Implement auto-scaling for ECS service
* Use AWS CodePipeline for CI/CD
* Add more comprehensive monitoring and alerting
* Implement backup strategies for RDS and DynamoDB
* Use AWS Config for compliance monitoring

---

## Setup Instructions

1. **Clone the repository**

   ```sh
   mkdir devops-assignment
   cd devops-assignment
   git clone https://github.com/Sclaassen/bonmoja-devops-assignment.git 
   ```

2. **Install Terraform**
   [Download here](https://www.terraform.io/downloads.html)

3. **Configure AWS credentials**
   Via [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) or set these env vars:

   ```
   export AWS_ACCESS_KEY_ID=xxxx
   export AWS_SECRET_ACCESS_KEY=yyyy
   export AWS_REGION=af-south-1
   ```

4. **Edit variables**
   Edit `variables.tf` to customize the environment, DB credentials, email, etc.

5. **Initialize Terraform**

   ```sh
   terraform init
   ```

6. **Plan changes**

   ```sh
   terraform plan
   ```

7. **Apply infrastructure**

   ```sh
   terraform apply
   ```

8. **Destroy infrastructure**

   ```sh
   terraform destroy
   ```

9. **Run health check**

   * Install Python 3 and `requests` library:

     ```sh
     pip install requests
     ```
   * Run the health check script:

     ```sh
     python scripts/health_check.py -url https://your-service-url.com
     ```
   * Defaults to `http://localhost:5678` if `-url` not provided.

---

## Overview

This project provisions a secure, cost-optimized, and production-ready AWS infrastructure using Terraform. It includes networking, compute, database, messaging, monitoring, and security best practices for cloud workloads.

---

## Architecture Diagram

![Architecture Diagram](./architecture-diagram.svg)

---

## Rationale

* **Modular Design:** Each AWS resource is managed in its own Terraform module for clarity and reusability.
* **Security:** Private subnets for sensitive resources, least-privilege IAM, and strict security groups.
* **Cost Optimization:** Uses Fargate Spot, right-sized RDS, and reserved instances for savings.
* **Monitoring:** CloudWatch logs and alarms for operational visibility and alerting.
* **Extensibility:** Easy to add new modules or extend existing ones for future needs.

---

## Modules

* **network**: VPC, public/private subnets, security groups
* **ecs**: Fargate cluster/service running `hashicorp/http-echo`
* **rds**: PostgreSQL database (private subnet, secure)
* **dynamodb**: Table for session/metadata
* **messaging**: SQS queue, SNS topic, email subscription
* **monitoring**: CloudWatch log groups and alarms
* **iam**: Roles and policies for least-privilege access

---

## Monitoring

**CloudWatch Alarms**

* RDS CPU > 80% for 5 minutes
* SQS queue depth > 100 for 10 minutes

**CloudWatch Log Groups**

* ECS, SQS, SNS, RDS

---

## Cost Optimization

### General AWS Strategies

| Cost Saver        | Savings        | Trade-off/Consequence                  |
| ----------------- | -------------- | -------------------------------------- |
| Spot/Fargate Spot | 70–90% cheaper | Not guaranteed, can be interrupted     |
| Savings Plans/RI  | 30–60% cheaper | Locked-in, lose flexibility            |
| Right-size RDS    | Lower cost     | May outgrow instance, needs monitoring |
| Turn off non-prod | Near-zero cost | Manual/automation overhead             |

#### Example: **ECS Cost Optimization**

* **Use Fargate Spot capacity** for ECS (up to 70–90% savings; beware of possible interruptions).
* **Rightsize task CPU/memory** to avoid over-provisioning.
* **Auto-scale tasks** based on CPU/memory or SQS depth.
* **Enable CloudWatch Container Insights** (monitor resource usage for further optimization).

#### Example: **RDS Cost Optimization**

* **Use db.t3.micro** (burstable, cost-effective) for dev/small workloads. (Note: T3 instances may not be available in all regions - especialy not af-south-1a/b).
* **Enable storage auto-scaling**.
* **Apply RDS Reserved Instances or Savings Plans** for production workloads.

---

## Usage

1. **Configure AWS credentials** (env or AWS CLI)
2. **Edit variables** in `variables.tf` as needed
3. **Initialize, plan, and apply Terraform** as above

---

## Health Check Script

A health check script is provided to verify the HTTP echo service is running and responsive.

**Usage:**

1. Ensure you have Python 3 and `requests` installed:

   ```sh
   pip install requests
   ```
2. Run:

   ```sh
   python scripts/health_check.py -url https://your-ecs-service-endpoint
   ```

* By default, the script checks `http://localhost:5678`.
* Logs results to `health_check.log` in the same directory.

---

## AWS IAM Role Requirements for Pipeline

The AWS IAM role used by your CI/CD pipeline (e.g., GitHub Actions) must have permissions to create, manage, tag, and read all resources defined in the Terraform configuration.
**Sample Policy (adjust ARNs for your environment):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": ["s3:*"], "Resource": ["arn:aws:s3:::demo-terraform-tf-state-bucket", "arn:aws:s3:::demo-terraform-tf-state-bucket/*"] },
    { "Effect": "Allow", "Action": ["codestar-connections:UseConnection"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["logs:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["dynamodb:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["ecs:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["iam:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["sqs:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["sns:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["ec2:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["cloudwatch:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["elasticloadbalancing:*"], "Resource": "*" },
    { "Effect": "Allow", "Action": ["rds:*"], "Resource": "*" }
  ]
}
```

> **Note:**
> For production, restrict actions and resources as much as possible.

---

## GitHub Environments & Pipeline Secrets

### 1. Create Environments

You should create at least the following environments in your GitHub repository:
- `demo`
- `dev`
- `staging`
- `production`

### 2. Add Environment Variables and Secrets

**Environment Secrets (per environment):**
- `DB_NAME` — RDS database name
- `DB_PASSWORD` — RDS database password
- `DB_USER` — RDS database username
- `TF_STATE_BUCKET_KEY` — Terraform state file key
- `TF_STATE_BUCKET_NAME` — Terraform state S3 bucket name
- `TF_STATE_DYNAMODB_TABLE` — DynamoDB table for state locking

**Environment Variables (per environment):**
- `AWS_REGION` — e.g., `af-south-1`
- `ENVIRONMENT` — e.g., `dev`
- `PRIVATE_SUBNET_CIDRS` — e.g., `["10.0.111.0/24","10.0.112.0/24"]`
- `PUBLIC_SUBNET_CIDRS` — e.g., `["10.0.101.0/24","10.0.102.0/24"]`
- `RDS_ALLOCATED_STORAGE` — e.g., `20`
- `RDS_INSTANCE_CLASS` — e.g., `db.t3.medium`
- `SNS_SUBSCRIPTION_EMAIL` — notification email
- `SUBNET_AVAILABILITY_ZONES` — e.g., `["af-south-1a", "af-south-1b"]`
- `VPC_CIDR` — e.g., `10.0.0.0/16`

**Repository Secrets (global):**
- `AWS_ACCESS_KEY_ID` — AWS access key for deployment
- `AWS_SECRET_ACCESS_KEY` — AWS secret key for deployment

### 3. How the Pipeline Uses These

The GitHub Actions workflow (`.github/workflows/terraform.yml`) uses these variables and secrets to configure Terraform and deploy to AWS. Make sure all are set before running the pipeline.

---

## Note on Docker Image and ECR

This project uses the public Docker image [`hashicorp/http-echo`](https://hub.docker.com/r/hashicorp/http-echo) for the ECS service. No custom image is built or pushed to ECR. The terraform configuration pulls this image directly from Docker Hub and runs it in the ECS Fargate service.

---

## Support

For questions or issues, open an issue on GitHub or contact \[[your-email@domain.com](mailto:your-email@domain.com)].
For improvements or bug reports, please create a pull request or submit an issue.

---
