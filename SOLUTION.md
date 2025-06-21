# Solution Overview

**Author:** Stefan Claassen
**Date:** June 2025

## Architecture Overview
This solution provisions a secure, modular AWS infrastructure using Terraform, following best practices for networking, compute, database, messaging, monitoring, and security. The architecture is designed for cost optimization, scalability, and operational visibility.

### Components
- **VPC**: Isolated network with public and private subnets
- **ECS (Fargate)**: Stateless HTTP service (hashicorp/http-echo) in public subnet
- **RDS (PostgreSQL)**: Managed database in private subnet
- **DynamoDB**: For session/metadata storage
- **SQS & SNS**: Messaging and notification
- **IAM**: Least-privilege roles and policies
- **CloudWatch**: Centralized logging and alarms

## Trade-offs
- **Fargate Spot**: Major cost savings but subject to interruption; suitable for stateless workloads
- **RDS**: Managed service for reliability, but higher cost than self-managed DB; right-sized for cost
- **Single Region**: Simpler and cheaper, but no multi-region HA
- **Secrets in Variables**: For demo, secrets are in variables; in production, use AWS Secrets Manager

## Security Notes
- Private subnets for RDS and sensitive resources
- Security groups restrict traffic to only necessary ports
- IAM roles follow least-privilege principle
- No hardcoded secrets in code (except demo defaults)
- Recommend enabling VPC endpoints for SQS/SNS/DynamoDB

## Monitoring Notes
- CloudWatch log groups for ECS, SQS, SNS, RDS
- Alarms:
  - RDS CPU > 80% for 5 minutes
  - SQS queue depth > 100 for 10 minutes
- SNS notifications for alarms
- Recommend enabling CloudWatch Container Insights for ECS

## Cost Strategies
- Use Fargate Spot for ECS (up to 70–90% savings)
- Reserved Instances/Savings Plans for RDS (30–60% savings)
- Right-size RDS and enable storage auto-scaling
- Automate stopping non-prod RDS outside business hours
- Use Graviton (ARM) instances where possible

---

**Author:** Stefan Claassen
**Date:** June 2025
