resource "aws_ecr_repository" "ecr_repository" {
  name                 = "ecr_repository"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_authorization_token" "ecr_token" {
  registry_id = "192636115768"
}

resource "kubernetes_secret" "ecr_credentials" {
  metadata {
    name      = "ecr-credentials"
    namespace = "app"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${data.aws_ecr_authorization_token.ecr_token.proxy_endpoint}" = {
          username = "AWS"
          password = data.aws_ecr_authorization_token.ecr_token.authorization_token
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}