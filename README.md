# EKS Node.js RDS Deployment
## Overview
This project demonstrates how to deploy a Node.js application on an Amazon EKS (Elastic Kubernetes Service) cluster that securely connects to an Amazon RDS database. The architecture ensures all components run within private subnets for security, with seamless secret management using the External Secrets Operator and container images pulled directly from Amazon ECR (Elastic Container Registry).

<h2 style="color: teal;">Step-by-Step Guide</h2>

## EKS  Setup 
### Important Configuration for eks :
One key attribute in our EKS cluster provisioning is:
```bash
bootstrap_cluster_creator_admin_permissions = true
```
``This setting grants administrative permissions to the IAM user or role that creates the EKS cluster. It ensures that the cluster creator is automatically added to the Kubernetes aws-auth ConfigMap with full access.``
### IAM Role Permissions
1. EKS Cluster Role

The IAM role used by the EKS control plane must have the following managed policies attached:

- ``AmazonEKSClusterPolicy``: 
**Grants permissions needed to create and manage EKS clusters.**
- ``AmazonEKSServicePolicy``:
**Allows EKS to manage linked AWS services like ELB and CloudWatch Logs.**

These permissions are essential for the cluster to communicate with other AWS services during provisioning and operation.

2. Node Group IAM Role

The IAM role assigned to worker nodes (EC2 instances) in the managed node group must include these policies:

- ``AmazonEKSWorkerNodePolicy``: Allows the node to connect to the EKS cluster and register itself as a worker.

- ``AmazonEC2ContainerRegistryPullOnly``:  Provides access to pull container images from Amazon ECR.

- ``AmazonEKS_CNI_Policy``: Allows the Amazon VPC CNI plugin to manage networking for pods running on the node.

These permissions are required for your pods to start correctly, communicate over the network, and pull container images from your private registry (ECR).

### Connect kubectl to an EKS 
- Create or update a kubeconfig file for your cluster.
```bash
aws eks update-kubeconfig --region region-code --name my-cluster
```
- Test your configuration
```bash
kubectl get svc
```

## 🗄️ RDS Setup and Credentials Management
To enable the Node.js application to interact with a database securely and privately, I provisioned Amazon RDS in a way that aligns with our EKS cluster's networking:

✅ RDS Configuration:
- Provisioned RDS within the same private subnet group used by the EKS cluster to ensure secure internal communication.
- I stored the RDS username and password in **AWS Secrets Manager**
- The secret is securely referenced in Kubernetes using **the External Secrets Operator (ESO)**
## Verify Communication Between EKS and RDS
### 🧪 Step-by-Step: Use a Test Pod with MySQL Client
- Run a test pod using Amazon Linux image:
```bash
kubectl run test-mysql \
  --image=amazonlinux \
  --restart=Never \
  --command -- sleep 3600
```
- Access the pod's shell:
```bash
kubectl exec -it test-mysql -- bash
```
- Inside the pod, install the MySQL client:
```bash
yum install -y mysql
```
- Connect to my RDS instance using the endpoint and credentials:
```bash
mysql -h <my-rds-endpoint> -u <my-db-username> -p
```
## the External Secrets Operator (ESO) setup

To securely fetch secrets from AWS Secrets Manager into Kubernetes, we used the External Secrets Operator (ESO) with IRSA (IAM Roles for Service Accounts). Below are the steps taken to set up ESO access in our EKS cluster.

### ✅ 1. Enable OIDC & Add Provider
I enabled OIDC (OpenID Connect) for our EKS cluster to allow Kubernetes service accounts (SAs) to securely assume AWS IAM roles.
```bash
This is crucial because it allows workloads running in Kubernetes (like Deployments, Jobs, Pods) to interact with AWS services such as Secrets Manager, S3, RDS, etc.—without embedding static AWS credentials in the application or environment.

Instead of hardcoding credentials in your code or ConfigMaps (which is insecure), the pod uses the service account that is linked to an IAM role. The IAM role is trusted to be assumed only by that specific service account (thanks to the OIDC identity provider), allowing secure, fine-grained access to AWS resources.
```

#### Steps via AWS Console:

- Go to the EKS Console, select your cluster.
- Under Configuration → Authentication, click Associate OIDC provider.
- Confirm and create the OIDC provider if it's not already associated.


### ✅ 2. Create IAM Role for ESO Access
To enable the External Secrets Operator (ESO) to retrieve secrets from AWS Secrets Manager, we created a dedicated IAM role with trust and permissions configured as follows:

- 🔐 Trust Policy: The IAM role is configured to trust the EKS cluster's OIDC identity provider, allowing a specific Kubernetes service account (in the app namespace) to assume the role securely.

- 🔑 Permissions: The role is attached to the managed policy SecretsManagerReadWrite, granting it access to read secrets from AWS Secrets Manager.

- 📁 Terraform directory: You can find the IAM role configuration under:
```bash
terraform/secret_manager/IAM_role.tf
```
```
┌──────────────────────────┐
│   Kubernetes Cluster     │
│         (EKS)            │
└──────────────────────────┘
              │
              ▼
┌──────────────────────────┐
│   Service Account (SA)   │◄────────────┐
│ Namespace: app           │             │
│ Name: app-service-account-sm │         │
└──────────────────────────┘             │
              │                          │ (OIDC Trust)
              ▼                          │
┌──────────────────────────┐             │
│        Pod (ESO)         │             │
│  Runs in EKS, uses SA    │             │
└──────────────────────────┘             │
              │                          ▼
              ├─────────────► OIDC Identity Provider
              │                 (enabled on EKS)
              ▼
┌──────────────────────────┐
│      IAM Role (SM-EKS)   │
│ - Trusts SA via OIDC     │
│ - Policy: SecretsManager │
└──────────────────────────┘
              │
              ▼
┌──────────────────────────┐
│ AWS Secrets Manager      │
│ Stores DB credentials    │
└──────────────────────────┘
```
![](/images/OIDC.png)


### ✅ 3. Create Kubernetes Service Account
I created a Kubernetes service account (app-service-account-sm) and annotated it with the IAM role ARN to allow pods to assume that role:
- 📁 K8s-manifests directory: You can find ServiceAccount configuration under:
```markdown
K8s-manifests/app_service_account.yaml
```
Any pod that uses this service account can securely pull secrets from AWS Secrets Manager using ESO.

### ✅ 4. Install and Configure External Secrets Operator (ESO)
📦 1. Install ESO via Helm

I use Helm to install the External Secrets Operator into a dedicated namespace and enable CRDs:
```bash 
helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets \
   external-secrets/external-secrets \
   -n external-secrets \
   --create-namespace \
   --set installCRDs=true
```
📁 2. Create a Namespace for Application Resources

I isolate our application components (including service account and pods) in a namespace named app:
- 📁 K8s-manifests directory: You can find namespace configuration under:
```markdown
K8s-manifests/app_namespace.yaml
```
🔐 3. Create a SecretStore to Connect with AWS Secrets Manager

The SecretStore resource configures ESO to use the IAM role assigned to the service account (via OIDC) to authenticate with AWS Secrets Manager:

- 📁 K8s-manifests directory: You can find SecretStore configuration under:
```bash
K8s-manifests/secretStore.yaml
```
🔄 4. Create an ExternalSecret to Sync Secrets

This resource tells ESO what to fetch from Secrets Manager and how to store it in Kubernetes:
- 📁 K8s-manifests directory: You can find ExternalSecret configuration under:
```bash
K8s-manifests/ExternalSecret.yaml
```
🧪 5. Result: ESO Creates a Kubernetes Secret

ESO will now automatically sync the secrets from AWS Secrets Manager and create a native Kubernetes Secret named ``db-credentials ``in the ``app namespace``.

6. ✅ Inject Secrets into Application Pods via Environment Variables

I then mount that secret into the pod as environment variables by referencing it in the Deployment manifest. 
- 📁 K8s-manifests directory: You can find deployment configuration under:
```bash
K8s-manifests/app_deployment.yaml
```

## 🔐 ECR Authentication for Kubernetes (Image Pull Secret)

### Retrieving ECR Authentication Token with Terraform
To enable our Kubernetes pods to securely pull container images from a private Amazon ECR repository, I provision a Kubernetes Secret of type` kubernetes.io/dockerconfigjson` using Terraform. This secret stores the Docker credentials needed by Kubernetes to authenticate with ECR, eliminating the need to embed static credentials in pods.

You can verify this secret is created and available in the app namespace by running:
```bash
kubectl get secrets -n app
```
Example output:
```
NAME               TYPE                             DATA   AGE
ecr-credentials    kubernetes.io/dockerconfigjson   1      7h22m

```
assign this secret to the default service account in the app namespace, which means:

Any pod deployed in the app namespace that uses the default service account automatically gains permission to pull images from ECR using this secret.

### 🧩 Terraform Configuration for Image Pull Secret
I used the `aws_ecr_authorization_token` data source to get temporary credentials from ECR, and then created a secret in the app
- 📁 terraform directory: You can find aws_ecr_authorization_token configuration under:
```bash
terraform/ecr/ecr.tf
```
🔐 This secret will be used by pods in the `app namespace` to authenticate against ECR and pull the Docker image without needing to hardcode credentials or manually configure access.

### 🔌 How Terraform Talks to Your EKS Cluster to Create Kubernetes Resources (e.g., ECR Credentials)
- 📁 terraform directory: You can find kubernetes provider configuration under:
```bash
terraform/provider.tf
```
✅ What this does
This Terraform setup tells Terraform how to communicate with your EKS cluster — specifically with the Kubernetes API Server — so that it can create native Kubernetes resources like:
- Secrets (e.g., for ECR authentication or DB credentials)
- ServiceAccounts
- ConfigMaps
- Deployments, Services, etc.
```
data "aws_eks_cluster" "eks_my_cluster" {
  name = "eks_my_cluster"  
}
```
🔍 Purpose:
- Retrieves metadata about your EKS cluster:
- API server endpoint (used by kubectl and other clients)
- CA certificate (for secure communication)
```
data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = data.aws_eks_cluster.eks_my_cluster.name
}
```
🔐 Purpose:
Generates a short-lived authentication token using AWS IAM. This token is required to interact with the cluster — essentially, it acts like logging in using AWS credentials.

```
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_my_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_my_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}
```
🔗 Purpose:
- This is the core piece — the Kubernetes provider. It uses the host, CA cert, and token to establish a secure connection to the EKS control plane.
- Once this is in place, Terraform can create Kubernetes-native resources inside cluster.

### 🛠️ Steps to Push a Docker Image to Amazon ECR After build Dockerfile
-  uthenticate Docker client to my Amazon ECR registry
```bash 
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
```
replacing aws_account_id and region with your AWS account ID and the region where your ECR repository is located
- build Dockerfile
```bash 
docker build -f Dockerfile -t nodejs-app ../
```
- Tag Docker Image
```bash 
docker tag your-image:latest aws_account_id.dkr.ecr.region.amazonaws.com/your-repository:latest

docker tag nodejs-app:latest 192636115768.dkr.ecr.us-east-1.amazonaws.com/ecr_repository
```
- Push the Image to ECR
```bash
docker push aws_account_id.dkr.ecr.region.amazonaws.com/your-repository:latest

docker push 192636115768.dkr.ecr.us-east-1.amazonaws.com/ecr_repository
```
## 🚀 Application Deployment
I created a Kubernetes Deployment for the Node.js application from this image 

- 📁 K8s-manifests directory: You can find deployment configuration under:
```bash
K8s-manifests/app_deployment.yaml
```

To expose the Node.js application externally, I created a Kubernetes Service of type LoadBalancer

- 📁 K8s-manifests directory: You can find deployment configuration under:
```bash
K8s-manifests/loadbalancer.yaml
```

![alt text](/images/app.png)

# References
- [permissions of EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/cluster-iam-role.html#create-service-role)

- [permissions of EKS node](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)
- [Connect kubectl to an EKS cluster by creating a kubeconfig file](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

- [Create an IAM OIDC provider for your cluster](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html)

- [Assign IAM roles to Kubernetes service accounts](https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html)
- [Pushing a Docker image to an Amazon ECR private repository](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html)