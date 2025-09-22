# Project Cerberus

Terraform project to provision a full AWS infrastructure running **WordPress** with an **RDS database**, **EC2 web server**, **EBS volume**, and a custom **VPC**.

---

## Overview

Project Cerberus demonstrates Infrastructure as Code (IaC) with Terraform by deploying a production-like environment on AWS:

- **VPC** with public, private, and database subnets  
- **Security Groups** for EC2 (SSH/HTTP) and RDS (DB access)  
- **EC2 Instance** with WordPress installed via `user_data` script  
- **RDS Instance** (MySQL/MariaDB) used by WordPress  
- **EBS Volume** attached for persistent storage  
- **Networking Module** to manage subnets, NAT, and SGs  

---

## Prerequisites

- AWS account with permissions for VPC, EC2, RDS, and EBS
- Terraform `>= 1.5`
- AWS credentials exported as environment variables:
  
  ```bash
  export AWS_ACCESS_KEY_ID=your_key
  export AWS_SECRET_ACCESS_KEY=your_secret
  export AWS_DEFAULT_REGION=eu-west-3
  ```

---

## Infrastructure Components

VPC (Networking Module)
	•	CIDR: 10.0.0.0/16
	•	Public subnets: 10.0.101.0/24, 10.0.102.0/24
	•	Database subnets: 10.0.201.0/24, 10.0.202.0/24
	•	NAT Gateway for private routing
	•	Security groups:
	•	EC2 SG: SSH (22) + HTTP (80)
	•	RDS SG: Allows port 3306 from EC2 SG

EC2 Module
	•	Amazon Linux 2 AMI
	•	Type: t2.micro
	•	Public subnet
	•	install_wordpress.sh runs via user data
	•	WordPress configured to use RDS as backend

RDS Module
	•	Engine: MySQL/MariaDB (3306)
	•	Multi-AZ enabled
	•	Private subnets only
	•	db_password injected via Terraform variable

EBS Module
	•	10 GiB volume
	•	Attached to EC2 instance
	•	Demonstrates block storage management

---

## Security Notes

	•	RDS is not publicly accessible. Only EC2’s SG can talk to it on port 3306.
	•	No AWS credentials or secrets are hardcoded.
	•	Sensitive values (e.g., db_password) are injected via environment variables.
	•	.gitignore excludes .terraform/, state files, and key material.

---

## ⚠️    Disclaimer

This project is intended **for educational and testing purposes only**.  
It deploys real AWS resources which may **incur costs** on your AWS account.  

- Do **not** use these configurations as-is in production.  
- Always secure your credentials and sensitive variables.  
- Ensure you understand the security implications before exposing services to the internet.  
- The maintainers and contributors are **not responsible** for any misuse, data loss, security issues, or unexpected charges that may result from using this code.  

Use at your own risk.
