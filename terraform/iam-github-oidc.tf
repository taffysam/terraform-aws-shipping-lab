# ============================================================
# GitHub OIDC Provider
# ============================================================

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-github-oidc"
    }
  )
}


# ============================================================
# GitHub CI / Terraform Plan Role
# ============================================================

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:taffysam@42932105/terraform-aws-shipping-lab@1350495530:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_terraform" {
  name = "${local.project_name}-github-terraform"

  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-github-terraform"
    }
  )
}


# ============================================================
# GitHub Deployment Role - LAB Environment
# ============================================================

data "aws_iam_policy_document" "github_deploy_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:taffysam@42932105/terraform-aws-shipping-lab@1350495530:environment:lab"
      ]
    }
  }
}

resource "aws_iam_role" "github_deploy" {
  name = "${local.project_name}-github-deploy"

  assume_role_policy = data.aws_iam_policy_document.github_deploy_trust.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-github-deploy"
    }
  )
}
    