version: 0.2

env:
  variables:
    TF_VERSION: 1.6.0
  
phases:
  install:
    commands:
      - echo "Installing Terraform ${TF_VERSION}"
      - wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
      - unzip -q terraform_${TF_VERSION}_linux_amd64.zip
      - mv terraform /usr/local/bin/
      - terraform --version
  pre_build:
    commands:
      - echo "Initializing Terraform"
      - terraform init
  build:
    commands:
      - echo "Validating Terraform configuration"
      - terraform validate
      - echo "Planning Terraform changes"
      - terraform plan
      - echo "Applying Terraform changes"
      - terraform apply -auto-approve
  post_build:
    commands:
      - echo "Terraform deployment completed successfully"
      - echo "Cleaning up Terraform configuration"
      - terraform destroy -auto-approve

