# Terraform

## Prerequisites

Ensure you have the following installed on your system:

- [Terraform](https://developer.hashicorp.com/terraform) (latest version recommended)

## Main (`./main`)

Main Terraform module for infrastructure

## Service (`./service`)

Terraform module to create service account for [Main](#main-main) terraform module.

## CheatSheet

```bash
# Init Terraform module
../scripts/init

# Set required variables for terraform from dotenv file
export $(grep -v '^#' ./.env | xargs)

# Unset required variables for terraform from dotenv file
unset $(grep -v '^#' ./.env | sed 's/=.*//' | xargs)
```
