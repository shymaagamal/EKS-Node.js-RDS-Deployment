resource "aws_iam_role" "SM_EKS_role" {
  name = "SM-EKS-role"

  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::192636115768:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/E3060449D5DF712D6FAA65CEB07759E9"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.us-east-1.amazonaws.com/id/E3060449D5DF712D6FAA65CEB07759E9:sub": "system:serviceaccount:app:app-service-account-sm"
        }
      }
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "SM_attach_policy" {
  role       = aws_iam_role.SM_EKS_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
