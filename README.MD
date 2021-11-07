# Overview

Terraform that can be used to provision resources for a web server running apache in a private subnet and a bastian host in public subent fronted by IGW in a single VPC.

# Contents

- [Modules](/modules) The directory for creating the needed modules base to be used for the deployment.
  - [S3 Module](/modules/s3)
  - [Server Module](/modules/server)
  - [VPC Module](/modules/vpc)
- [main.tf](/main.tf) The base file for the deployment.
- [variables.tf](/variables.tf) The variables file defines the main variables used for the deployment.
- [terraform.auto.tfvars](/terraform.auto.tfvars) The variables file defines the vaules for the variables used for the deployment.

# Requirements
- An AWS Account

# Prerequisites
- Terraform istalled on the control machine where you are running the code.
Verify by running 
terraform --version 
- Ensure you have full aws access to the account via IAM credentils stored in "~/.aws/credentials" or override the file in the aws provider in [main.tf](/main.tf).
- Backend S3 bucket to store the state file.
- EC2 Key used to ssh.
- Location for the public key to store and use.
---

# Variables
- These are the vaules you can override in [terraform.auto.tfvars](/terraform.auto.tfvars) file

|Name | Type  |Description   |
|---|---|---|
| aws_region | *string* | aws region where the app will be deployed |
|  role | *string* | Can only be dev or test |
|  project | *string* | project name that will be used as a part of the team bucket name |
|  owner_email | *string* | Email to contact owner |
|  aws_keypair | *string* | EC2 key pair name to access the hosts |
|  public_key_location | *string* | path to public key on the control machine 


# Modules

### S3 Module

**Resources:**
- [**user/aws_s3_bucket**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) *S3 Bucket created based on role for users to acces*
- [**keystore/aws_s3_bucket**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) *S3 Bucket created to store RSA public keys*
- [**main/aws_s3_bucket_public_access_block**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) *Block public access to S3 bucket*
- [**keys/aws_s3_bucket_object**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) *Uploading the example public key*


**Outputs:**
|Name | Type  |Description   |
|---|---|---|
| keystore_bucket	  | *string*  |  Name of the keystore bucket	|
| team_project_bucket  | *string*  |  Name of the team bucket	

-------

## VPC Module

**Resources:**
- [**main/aws_vpc**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) *VPC the application*
- [**main/aws_internet_gateway**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) *Internet gateway*
- [**private/aws_subnet**](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html) *Private subnet used for the application*
- [**public/aws_subnet**](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html) *Public subnet used for the application*
- [**main/aws_eip**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) *Elastic IP resource*
- [**main/aws_nat_gateway**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) *NatGateway*
- [**public/aws_route_table**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) *Public route table*
- [**private/aws_route_table**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) *Private route table*
- [**public/aws_route**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) *Public route*
- [**private/aws_route**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) *Private route*
- [**public/aws_route_table_association**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) *Public route table association*
- [**private/aws_route_table_association**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) *Private route table association*
- [**public/aws_security_group**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) *Public security group*
- [**private/aws_security_group**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) *Private security group*


-------

## Server Module

**Resources:**
- [**bastian/aws_instance**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) *Bastian server*
- [**server/aws_instance**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) *Server running apache*
- [**bastionRole/aws_iam_role**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) *Bastion IAM role for s3 access to the keystore and user bucket*
- [**server_rw_Role/aws_iam_role**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) *Server Read Write IAM role for for s3 access to the keystore and user bucket and ec2 actions*
- [**server_read_Role/aws_iam_role**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) *Server Read IAM role for read only for s3 access to the keystore and user bucket*
- [**bastion_instance_profile/aws_iam_instance_profile**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) *Bastian IAM instance profile*
- [**server_rw_instance_profile/aws_iam_instance_profile**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) *Server read write IAM instance profile*
- [**server_read_instance_profile/aws_iam_instance_profile**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) *Server read only IAM instance profile*
- [**bastion_policy/aws_iam_role_policy**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) *Bastian IAM policy*
- [**server_rw_policy/aws_iam_role_policy**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) *Server read write policy*
- [**server_read_policy/aws_iam_role_policy**](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) *Server read only IAM  IAM policy*


**Outputs:**
|Name | Type  |Description   |
|---|---|---|
| bastion_public_dns	 | *string* | Bastian DNS name |
| server_address | *string* | Apache server ip address |
| bastion_instance_profile | *string* | Bastian instance profile |
| server_rw_instance_profile | *string* | Apache server read write instance profile  |
| server_read_instance_profile | *string* | Apache server read instance profile


-------
## Usage

**Prepare code**
1. Edit [terraform.auto.tfvars](/terraform.auto.tfvars) for the vaules refernced in Variables above.
2. Edit [main.tf](/main.tf) in the root directory, remove the comment and add the bucket name under [ backend "s3"] to store the state file.

**Using the control machine running terraform to run the below from the root directory**
1. terraform init
2. terraform apply -auto-approve
3. You can view the outputs running
terraform output

**Clean up**
1. terraform destroy
