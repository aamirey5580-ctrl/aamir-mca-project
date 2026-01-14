# 📄 Project Proposal

## Automated Deployment of Node.js and MongoDB Application on GKE using Terraform

---

### Student Information

| Detail | Value |
|--------|-------|
| **Name** | Aamir Qureshi |
| **Roll No** | AA.SC.P2MCA2401074 |
| **Date** | 19/10/2025 |

---

### Abstract

This project aims to automate the infrastructure provisioning and deployment of a full-stack application utilizing **Terraform**, **Google Cloud Platform (GCP)**, and **Google Kubernetes Engine (GKE)**. The chosen application stack comprises a containerized **Node.js-based web application** (REST API) and a **MongoDB database** functioning as a backend service.

The primary objective is to establish an end-to-end DevOps pipeline wherein the requisite infrastructure (networking, IAM, Kubernetes cluster) is provisioned via Terraform, and the application is subsequently deployed to the GKE cluster through Kubernetes manifests.

This deployment will incorporate fundamental Kubernetes concepts, including:
- Deployments & StatefulSets
- Services (ClusterIP, LoadBalancer)
- Persistent Volumes
- ConfigMaps & Secrets

> This project underscores the significance of Infrastructure as Code and container orchestration in the management of scalable, modern cloud-native applications.

---

### Assumptions & Declarations

| # | Declaration |
|---|-------------|
| 1 | The project will leverage **GCP Free Tier** resources for development and deployment |
| 2 | **Terraform** will be employed for the creation of GCP resources (VPC, GKE, IAM, firewall rules) |
| 3 | The application stack will consist of a **Node.js container** and a **MongoDB container**, both deployed within Kubernetes using YAML manifests |
| 4 | **Persistent volumes** will be utilized for MongoDB data storage |
| 5 | The scope does not include production-grade CI/CD or external monitoring, focusing solely on core infrastructure and deployment |

---

### Main Objectives & Deliverables

#### Objectives

1. ✅ Provision GCP infrastructure using Terraform in a modular and reusable format
2. ✅ Deploy a two-tier application (Node.js + MongoDB) utilizing Kubernetes on GKE
3. ✅ Configure Kubernetes resources including persistent volumes, services, and environment variables
4. ✅ Ensure the application's accessibility via LoadBalancer and operational functionality
5. ✅ Prepare comprehensive documentation, architecture diagrams, and source code

#### Deliverables

| Deliverable | Description |
|-------------|-------------|
| Terraform Code | Infrastructure as Code for GCP resources |
| Kubernetes Manifests | YAML files for application deployment |
| Node.js REST API | Sample application with CRUD operations |
| Documentation | README, architecture diagrams, deployment guide |
| Presentation | Project presentation and demo |

---

### Timeline & Milestones

| Week | Milestone |
|------|-----------|
| **1-2** | Understanding project requirements, GCP, and Terraform fundamentals |
| **3** | Creating GCP account and setting up service credentials |
| **4-5** | Writing Terraform code for VPC, GKE cluster, and IAM |
| **6-7** | Dockerizing Node.js and MongoDB applications |
| **8** | Writing Kubernetes manifests for application and database |
| **9-10** | Application deployment, testing, and service exposure |
| **11** | Adding volume mounts and secret management |
| **12-13** | Documentation and infrastructure diagramming |
| **14+** | Final report and presentation preparation |

---

### Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Terraform** | Provisioning GCP resources (IaC) |
| **Google Cloud Platform** | Cloud infrastructure and Kubernetes hosting |
| **Google Kubernetes Engine** | Managed Kubernetes cluster |
| **Docker** | Containerizing Node.js and MongoDB |
| **kubectl** | Kubernetes CLI for deployments |
| **Git & GitHub** | Version control |
| **Visual Studio Code** | Development environment |
| **Laptop/Desktop** | Minimum 4GB RAM, internet connectivity |

---

### Learning Outcomes

| Topic | Description |
|-------|-------------|
| **Infrastructure as Code** | Utilizing Terraform to define and provision cloud infrastructure |
| **Kubernetes Basics** | Deployments, Pods, Services, Secrets, and Persistent Volumes |
| **Containerization** | Dockerizing Node.js and MongoDB for cloud-native deployment |
| **GCP Resource Management** | Working with IAM, networking, Kubernetes Engine |
| **DevOps Practices** | Automating infrastructure and application lifecycle |
| **Documentation** | Creating detailed records and visual diagrams |

---

### Signature

| | |
|-|-|
| **Student Name** | Aamir Qureshi |
| **Date** | 19/10/2025 |
| **Signature** | _________________ |

