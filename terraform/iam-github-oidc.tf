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
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:taffysam/terraform-aws-shipping-lab:ref:refs/heads/main"
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