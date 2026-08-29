name: Terraform CI

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest

    permissions:
      id-token: write
      contents: read

    defaults:
      run:
        working-directory: terraform

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
      
	

      - name: Inspect GitHub OIDC claims
        shell: bash
        run: |
          TOKEN=$(curl -sLS \
            -H "Authorization: Bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" \
            "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=sts.amazonaws.com" \
            | jq -r '.value')

          PAYLOAD=$(echo "$TOKEN" | cut -d '.' -f2)
          PAYLOAD="${PAYLOAD}$(printf '=%.0s' $(seq 1 $(( (4 - ${#PAYLOAD} % 4) % 4 ))))"

          echo "$PAYLOAD" | tr '_-' '/+' | base64 -d | jq '{
            aud,
            sub,
            repository,
            repository_id,
            repository_owner,
            repository_owner_id,
            ref
          }'

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v6.2.3
        with:
          role-to-assume: "arn:aws:iam::325502190209:role/terraform-shipping-lab-github-terraform"
          role-session-name: terraform-shipping-lab-ci
          aws-region: af-south-1
	

      - name: Verify AWS identity
        run: aws sts get-caller-identity

      - name: Terraform Format Check
        run: terraform fmt -check -recursive

      - name: Terraform Init
        run: terraform init -backend=false

      - name: Terraform Validate
        run: terraform validate