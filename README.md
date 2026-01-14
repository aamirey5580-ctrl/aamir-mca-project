# 🚀 Node.js + MongoDB Application on GKE

> Automated Infrastructure Deployment using Terraform and Kubernetes

[![GCP](https://img.shields.io/badge/GCP-GKE-blue?logo=google-cloud)](https://cloud.google.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)](https://terraform.io)
[![Node.js](https://img.shields.io/badge/Node.js-API-green?logo=node.js)](https://nodejs.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-Database-green?logo=mongodb)](https://mongodb.com)

---

## 📋 Project Information

| Field | Details |
|-------|---------|
| **Student Name** | Aamir Qureshi |
| **Roll Number** | AA.SC.P2MCA2401074 |
| **Project** | MCA Final Year Project |
| **Date** | October 2025 |

---

## 🎯 Overview

This project demonstrates the automated deployment of a **two-tier application** on Google Kubernetes Engine (GKE) using Infrastructure as Code (IaC) principles.

### Application Stack

```
┌─────────────────────────────────────────┐
│              Load Balancer               │
│              (External IP)               │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│           Node.js REST API               │
│          (2+ replicas with HPA)          │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│              MongoDB                     │
│        (Persistent Storage)              │
└─────────────────────────────────────────┘
```

---

## 🏗️ Architecture

```
                    ┌──────────────────────────────────────────┐
                    │         Google Cloud Platform            │
                    │                                          │
                    │   ┌──────────────────────────────────┐  │
                    │   │         VPC Network               │  │
                    │   │                                   │  │
                    │   │  ┌─────────────────────────────┐ │  │
                    │   │  │      GKE Cluster            │ │  │
                    │   │  │                             │ │  │
                    │   │  │  ┌────────┐  ┌──────────┐  │ │  │
     Internet ──────┼───┼──┼─▶│  API   │─▶│  MongoDB │  │ │  │
                    │   │  │  │  Pods  │  │  Pod     │  │ │  │
                    │   │  │  └────────┘  └──────────┘  │ │  │
                    │   │  │       │            │       │ │  │
                    │   │  │       ▼            ▼       │ │  │
                    │   │  │  ┌────────────────────┐    │ │  │
                    │   │  │  │  Persistent Volume │    │ │  │
                    │   │  │  └────────────────────┘    │ │  │
                    │   │  └─────────────────────────────┘ │  │
                    │   └──────────────────────────────────┘  │
                    └──────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
aamir-mca-project/
├── infra/                    # Terraform Infrastructure
│   ├── main.tf               # Main configuration
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # Output values
│   └── terraform.tfvars.example
│
├── k8s/                      # Kubernetes Manifests
│   ├── 00-namespace.yaml     # Namespace
│   ├── 01-secrets.yaml       # Credentials
│   ├── 02-configmap.yaml     # Configuration
│   ├── 03-mongodb-pvc.yaml   # Storage
│   ├── 04-mongodb-deploy.yaml# MongoDB StatefulSet
│   ├── 05-mongodb-svc.yaml   # MongoDB Service
│   ├── 06-api-deploy.yaml    # API Deployment
│   ├── 07-api-svc.yaml       # API LoadBalancer
│   ├── 08-api-hpa.yaml       # Auto-scaling
│   └── 09-app-code-configmap.yaml
│
├── app/                      # Application Source
│   ├── server.js             # Node.js API
│   ├── package.json          # Dependencies
│   └── Dockerfile            # Container image
│
├── Makefile                  # Deployment commands
└── README.md                 # Documentation
```

---

## 🛠️ Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| gcloud CLI | Latest | GCP authentication |
| Terraform | >= 1.0 | Infrastructure provisioning |
| kubectl | >= 1.28 | Kubernetes management |
| make | Any | Build automation |

---

## 🚀 Quick Start

### Step 1: Configure GCP

```bash
# Authenticate
gcloud auth login
gcloud auth application-default login

# Set project
gcloud config set project YOUR_PROJECT_ID

# Enable APIs
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable iam.googleapis.com
```

### Step 2: Configure Terraform

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project ID
```

### Step 3: Deploy Everything

```bash
# Using Makefile (recommended)
make init      # Initialize Terraform
make apply     # Create infrastructure
make k8s-deploy # Deploy application

# Check status
make status
make get-url
```

---

## 📖 Makefile Commands

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make init` | Initialize Terraform |
| `make plan` | Preview infrastructure changes |
| `make apply` | Create GCP infrastructure |
| `make k8s-deploy` | Deploy app to Kubernetes |
| `make status` | Check deployment status |
| `make get-url` | Get application URL |
| `make logs` | View API logs |
| `make destroy` | Destroy everything |

---

## 🔌 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API information |
| GET | `/health` | Health check |
| GET | `/api/tasks` | List all tasks |
| POST | `/api/tasks` | Create new task |
| GET | `/api/tasks/:id` | Get single task |
| PUT | `/api/tasks/:id` | Update task |
| DELETE | `/api/tasks/:id` | Delete task |

### Example Usage

```bash
# Get all tasks
curl http://<EXTERNAL-IP>/api/tasks

# Create task
curl -X POST http://<EXTERNAL-IP>/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Kubernetes", "status": "pending"}'
```

---

## 🔐 Security Features

- ✅ Private GKE cluster
- ✅ Cloud NAT for outbound traffic
- ✅ Kubernetes Secrets for credentials
- ✅ Service Account with minimal permissions
- ✅ Shielded GKE nodes
- ✅ Workload Identity enabled

---

## 💰 Cost Optimization

- Preemptible VMs (70% cheaper)
- Zonal cluster (vs regional)
- Auto-scaling based on load
- Small machine types for dev

---

## 🧹 Cleanup

```bash
# Remove application
make k8s-delete

# Destroy infrastructure
make destroy
```

---

## 👤 Author

**Aamir Qureshi**  
Roll No: AA.SC.P2MCA2401074  
MCA Final Year Project

---

## 📄 License

This project is for educational purposes.

