data "aws_iam_policy_document" "github_terraform_permissions" {
  statement {
    sid    = "TerraformStateBucketAccess"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::terraform-shipping-lab-state-tafadzwa"
    ]
  }

  statement {
    sid    = "TerraformStateObjectAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::terraform-shipping-lab-state-tafadzwa/terraform-aws-shipping-lab/lab/terraform.tfstate"
    ]
  }

  statement {
    sid    = "TerraformStateLockAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::terraform-shipping-lab-state-tafadzwa/terraform-aws-shipping-lab/lab/terraform.tfstate.tflock"
    ]
  }
}

resource "aws_iam_policy" "github_terraform" {
  name   = "${local.project_name}-github-terraform"
  policy = data.aws_iam_policy_document.github_terraform_permissions.json
}

resource "aws_iam_role_policy_attachment" "github_terraform" {
  role       = aws_iam_role.github_terraform.name
  policy_arn = aws_iam_policy.github_terraform.arn
}

resource "aws_iam_role_policy_attachment" "github_read_only" {
  role       = aws_iam_role.github_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}