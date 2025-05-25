# create EKS ,ecr, database, SM and EKS can communicate with Database

# create External Secret operator (ESO) in EKS using helm 
[this is resource for creating this](https://external-secrets.io/latest/introduction/getting-started/)
## this explaain and calify what is ESO

[Getting Started with External Secrets Operator](https://www.kubeblog.com/security/getting-started-with-external-secrets-operator/)
[Centralized Secrets with ESO and AWS Secrets Manager](https://www.kubeblog.com/security/centralized-secrets-using-eso-and-aws-secrets-manager/)


1. 
```bash 
helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets \
   external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace
```
2. Associate OIDC Provider
[creating an IAM OIDC (OpenID Connect) provider is essential for enabling IAM Roles for Service Accounts (IRSA) in Amazon EKS. This setup allows Kubernetes service accounts to assume IAM roles, granting your pods secure access to AWS services like Secrets Manager without embedding static credentials.](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html)










1. aws   