#----------------------------------------------
#  You need to run eureka first by hand, 
#  and then inspect the container and edit the
#  spring-config env file with the load balancer
#  IP address. Also put this in the eureka only
#  environment file.
#   
#  Then run the spring config
#  by hand, inspect the container and get the 
#  load balancer IP to set into the env files
#  that use spring config only.
#----------------------------------------------
# echo "create group for Eureka"
cd ~/ibm-cloud-architecture/refarch-cloudnative-netflix-eureka/bluemix 
./deploy-container-group.sh

echo "sleeping 60 seconds for Eureka to start"
sleep 60

# echo "create group for the config server"
# cf ic group create --name spring-config -p 8888 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-springconfig-bx registry.ng.bluemix.net/supercontainers/spring-config:dev

# echo "sleeping 120"
# sleep 120

echo "Create mysql container in BX, listening on port 3306"
cf ic run -m 128 --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=Pass4Admin123 -e MYSQL_USER=dbuser -e MYSQL_PASSWORD=Pass4dbUs3R -e MYSQL_DATABASE=inventorydb registry.ng.bluemix.net/$(cf ic namespace get)/mysql:cloudnative

echo "sleeping 60 secs for container to start up"
sleep 60

echo "Loading data into mysql"
cf ic exec -it mysql sh load-data.sh

echo "sleeping 3"
sleep 3


echo "Running the inventory service listening on port 8080"

cf ic group create -p 8080 -m 128 --min 1 --auto --name micro-inventory-group -e "eureka_client_serviceUrl_defaultZone=http://netflix-eureka-supercontainers.mybluemix.net/eureka/" -e "spring.datasource.url=jdbc:mysql://172.30.0.6:3306/inventorydb" -e "spring.datasource.username=dbuser" -e "spring.datasource.password=Pass4dbUs3R" registry.ng.bluemix.net/$(cf ic namespace get)/inventoryservice:cloudnative

sleep 60

echo "Running the social review service listening on port 8081"
cf ic group create -p 8081 -m 128 --min 1 --auto --name micro-socialreview-group -e "eureka_client_serviceUrl_defaultZone=http://netflix-eureka-supercontainers.mybluemix.net/eureka/" registry.ng.bluemix.net/$(cf ic namespace get)/socialreviewservice

# cf create-route cloudnative-dev mybluemix.net --hostname dbellagio-social-lab
# cf ic route map -n dbellagio-social-lab -d mybluemix.net micro-socialreview-group

echo waiting  60 secs for social to startup
sleep 60

echo "create group for zuul, pass in Eureka"
cd ~/ibm-cloud-architecture/refarch-cloudnative-netflix-zuul/bluemix
./deploy-container-group.sh http://netflix-eureka-supercontainers.mybluemix.net/

