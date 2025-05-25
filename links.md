this link for how to create cluster
[How to create cluster](https://docs.aws.amazon.com/eks/latest/userguide/network-reqs.html)

this link to know required permissions for cluster 
[what are permissions for EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/cluster-iam-role.html#create-service-role)

this link to know required permissions for group nodes
[what are permissions for EKS nodes](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)

this link is clarifying what the importance of tagging for network componenets like vpc and subnets 
[waht are tags that required for network components to help EKS to manage its recources through these network components only](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.6/deploy/subnet_discovery/)



## additional resources
[trivy](https://medium.com/@calvineotieno010/improving-your-ci-cd-pipeline-helm-charts-security-scanning-with-trivy-and-github-actions-acc081df2c2d)

[Step-by-Step Guide: Creating an EKS Cluster with Terraform Resources, IAM Roles for Service Accounts, and EKS Cluster Autoscaler](https://medium.com/@tech_18484/step-by-step-guide-creating-an-eks-cluster-with-terraform-resources-iam-roles-for-service-df1c5e389811)

[This is how to create rds with eks](https://dev.to/bensooraj/accessing-amazon-rds-from-aws-eks-2pc3)
[HOW Kubectl auth with EKS](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)
Iac

1. Amazon EKS Cluster
The Kubernetes control plane managed by AWS.

Your worker nodes will run in private subnets within your VPC.

Managed via Terraform to create the cluster and node groups.

2. Amazon ECR (Elastic Container Registry)
Private Docker container registry.

Used to store and version your Node.js app Docker images.

Jenkins will push your built images here; ArgoCD (or any GitOps tool) will pull images from here for deployment.

Terraform-managed aws_ecr_repository resource.

3. AWS Secrets Manager
Secure place to store secrets such as:

Database credentials (username, password)

Redis credentials (if applicable)

Any API keys or tokens needed by your app or Kubernetes components

External Secrets Operator (ESO) pulls these secrets securely into Kubernetes secrets.

Managed with Terraform (aws_secretsmanager_secret and aws_secretsmanager_secret_version).

4. Amazon RDS (Relational Database Service)
Managed MySQL (or other relational DB) outside the cluster.

Provides a highly available, scalable, and secure database backend for your Node.js app.

Terraform aws_db_instance resource.

Must be deployed in private subnets with proper security groups allowing access only from your EKS nodes.

 

 # Steps 

 1- sg of rds for cider make it var
 2- secret operator
 2- ardocd 
 3- make sure cluster can access ecr



install secret operator in Eks ---> deploy nodejs app that fetch html when reach rdb ---> rds use these secrets --->download argocd to deploy application  