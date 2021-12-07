## Word Press Site

# Architecture Diagram

  <img src="/Architecture_Diagrams/Wordpress_Site.PNG" alt="WordPress"/>

The one step that we need to do post installing the code using terraform is to create a database user for the app to talk to the RDS database.

Steps:
export MYSQL_HOST=wordpress.cfeabay48nsn.ap-south-1.rds.amazonaws.com
mysql --user=admin --password=Welcome123 wordpress

CREATE USER 'wordpress' IDENTIFIED BY 'Sreadmin@123';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpress;
FLUSH PRIVILEGES;
Exit

WOrdpress URL : https://wordpress.sre-assignment.click (If this does not work please use the ELB DNS name as some organization restrict .click domain)

## API APP (Basic CRUD API)

URL : https://api.sre-assignment.click/items If this does not work please use the API Gateway URL as some organization restrict .click domain)
You use POSTMAN or any other REST API tools to send GET,PUT,POST,DELETE etc to invoke the lambda function via the API gateway.
The database used in the backed is DynamoDB


Monitoring can be done using Cloudwatch and metrics and logs are getting pushed to it.


# How to use the code

* Get into the "SRE-ASSIGNMENT-FINAL-ENHANCED" folder and run terraform init. This will download all required plugins and referenced modules.
* The provider configuration is using a profile called assignment which is configured on my local machine.
* Run "terraform plan" to check what resouces would be created once you are ok with this run "terraform apply". This creates all the resources that are declared in the code. (For now i have everything deployed in the us-east-1 region)
* The variables are all declared using local.tf.
* Once the resouces are deployed wait for some time so that everything is ready as in wordpress we have a bootstrap script that runs once the ec2 instances are up.
* The worpress site can be accessed using the URL : https://wordpress.sre-assignment.click . If you need to create a login for your self use this URL : https://wordpress.sre-assignment.click/wp-login.php
* The Architecture diagram is in the folder named Architecture_Diagrams within the folder.
List of recources created for the above project
> VPC with private & public subnets
> Routetables for each subnet to control traffic movement
> NAT Gateway
> Internet Gateway
> Autoscalling group with Launch configuation
> Ec2 instances with host the webserver
> Load balancer
> Domain name
> Route53 hosted zone entry
> ACM for domain certificate
> RDS for database

* We have also created a HTTP API(CRUD) using the below resources
> API Gateway
> Lambda 
> DynamoDB
> Domain Name
> ACM

Sample URL that can used to PUT a request
curl -v -X "PUT" -H "Content-Type: application/json" -d "{\"id\": \"324\", \"price\": 75000, \"name\": \"Suraj\", \"size\": \"Medium\", \"colour\": \"Black\", \"weight\": \"83KG\", \"country\": \"India\"}" https://olhbsmtdv6.execute-api.us-east-1.amazonaws.com/items
