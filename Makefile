# ============================================
# Makefile for Project Deployment
# Node.js + MongoDB on GKE
# Author: Aamir Qureshi
# ============================================

.PHONY: help init plan apply destroy k8s-deploy k8s-delete status clean

# Default target
help:
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════╗"
	@echo "║     Node.js + MongoDB on GKE - Deployment Commands       ║"
	@echo "║                  Author: Aamir Qureshi                   ║"
	@echo "╚══════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "  Infrastructure Commands:"
	@echo "    make init        - Initialize Terraform"
	@echo "    make plan        - Preview infrastructure changes"
	@echo "    make apply       - Create GCP infrastructure"
	@echo "    make destroy     - Destroy all infrastructure"
	@echo ""
	@echo "  Kubernetes Commands:"
	@echo "    make k8s-deploy  - Deploy application to GKE"
	@echo "    make k8s-delete  - Remove application from GKE"
	@echo ""
	@echo "  Utility Commands:"
	@echo "    make status      - Check deployment status"
	@echo "    make get-url     - Get application URL"
	@echo "    make logs        - View application logs"
	@echo "    make clean       - Clean temporary files"
	@echo ""

# ============================================
# Infrastructure Commands
# ============================================

init:
	@echo "🔧 Initializing Terraform..."
	@cd infra && terraform init

plan:
	@echo "📋 Planning infrastructure changes..."
	@cd infra && terraform plan

apply:
	@echo "🚀 Creating GCP infrastructure..."
	@cd infra && terraform apply -auto-approve
	@echo ""
	@echo "⚙️  Configuring kubectl..."
	@$$(cd infra && terraform output -raw get_credentials_cmd)
	@echo "✅ Infrastructure ready!"

destroy:
	@echo "🗑️  Destroying infrastructure..."
	@cd infra && terraform destroy -auto-approve

# ============================================
# Kubernetes Commands
# ============================================

k8s-deploy:
	@echo "📦 Deploying application to Kubernetes..."
	@kubectl apply -f k8s/00-namespace.yaml
	@sleep 2
	@kubectl apply -f k8s/01-secrets.yaml
	@kubectl apply -f k8s/02-configmap.yaml
	@kubectl apply -f k8s/03-mongodb-pvc.yaml
	@kubectl apply -f k8s/09-app-code-configmap.yaml
	@echo "🗄️  Deploying MongoDB..."
	@kubectl apply -f k8s/04-mongodb-deploy.yaml
	@kubectl apply -f k8s/05-mongodb-svc.yaml
	@echo "⏳ Waiting for MongoDB to be ready..."
	@kubectl wait --for=condition=ready pod -l app=mongodb -n mca-app --timeout=180s || true
	@echo "🌐 Deploying Node.js API..."
	@kubectl apply -f k8s/06-api-deploy.yaml
	@kubectl apply -f k8s/07-api-svc.yaml
	@kubectl apply -f k8s/08-api-hpa.yaml
	@echo "✅ Deployment complete!"
	@$(MAKE) get-url

k8s-delete:
	@echo "🗑️  Removing application from Kubernetes..."
	@kubectl delete -f k8s/ --ignore-not-found=true
	@echo "✅ Application removed!"

# ============================================
# Utility Commands
# ============================================

status:
	@echo ""
	@echo "📊 Deployment Status"
	@echo "===================="
	@echo ""
	@echo "Pods:"
	@kubectl get pods -n mca-app -o wide 2>/dev/null || echo "  No pods found"
	@echo ""
	@echo "Services:"
	@kubectl get svc -n mca-app 2>/dev/null || echo "  No services found"
	@echo ""
	@echo "PVC:"
	@kubectl get pvc -n mca-app 2>/dev/null || echo "  No PVC found"
	@echo ""

get-url:
	@echo ""
	@echo "🔗 Getting Application URL..."
	@echo "   (LoadBalancer may take 2-3 minutes to provision)"
	@echo ""
	@IP=$$(kubectl get svc nodejs-api-svc -n mca-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null); \
	if [ -n "$$IP" ]; then \
		echo "╔══════════════════════════════════════════════╗"; \
		echo "║  🌐 Application URL: http://$$IP              "; \
		echo "║  📊 Health Check:    http://$$IP/health       "; \
		echo "║  📝 API Endpoint:    http://$$IP/api/tasks    "; \
		echo "╚══════════════════════════════════════════════╝"; \
	else \
		echo "⏳ LoadBalancer IP not yet assigned. Run 'make get-url' again."; \
	fi

logs:
	@echo "📜 Application Logs (last 50 lines):"
	@kubectl logs -l app=nodejs-api -n mca-app --tail=50 2>/dev/null || echo "No logs available"

logs-mongo:
	@echo "📜 MongoDB Logs (last 50 lines):"
	@kubectl logs -l app=mongodb -n mca-app --tail=50 2>/dev/null || echo "No logs available"

clean:
	@echo "🧹 Cleaning temporary files..."
	@cd infra && rm -rf .terraform .terraform.lock.hcl terraform.tfstate.backup tfplan
	@echo "✅ Clean complete!"

