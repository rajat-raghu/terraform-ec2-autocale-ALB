# terraform-ec2-autocale-ALB
terraform script to create auto scaled ec2 in private subnet with connected with application LB to connect.

steps:
1. terraform init
2. terraform plan
3. terrafrom apply


# go to aws vpc in default VPC -> squrity groups 
 in created sg  change inbound rule to  to anywehere (0.0.0.0:0)
 
 to destroy
 terraform destroy
