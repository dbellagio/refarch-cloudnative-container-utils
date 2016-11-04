#----------------------------------------------
#  You need to run eureka first by hand,
#  and then inspect the container and edit the
#  spring-config env file with the 
#  IP address of Eureka. Also put this in the eureka only
#  environment file.
#
#  Then run the spring config
#  by hand, inspect the container and get the IP address
#  to set into the env files
#  that use spring config only.
#----------------------------------------------
#
# Note: the -p 9080 lines are the Liberty container options, which are not in use

# Do these by hand, that is why they are commented out here

# TODO: Insert pause/prompt instead

# run the eureka container
# echo "Running eureka"
# docker run --name netflix-eureka -p 8761:8761 -d netflix-eureka:latest

# echo "waitng 60 sec for eureka to get running"
# sleep 60

# run the config server
# echo "Running config server"
# docker run --name spring-config -p 8888:8888 --env-file env-configserver-local -d spring-config:latest

# echo "waitng 90 sec for config server to get running"
# sleep 90

# run the rest which are runnable JARs in the Java 8 base image
echo Changing to  ~/ibm-cloud-architecture/refarch-cloudnative-mysql
cd ~/ibm-cloud-architecture/refarch-cloudnative-mysql

# Run the local mysql
echo "Running mysql"
docker run --name mysql -v $PWD/scripts:/home/scripts -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin123 -e MYSQL_USER=dbuser -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=inventorydb -w /home/scripts -d mysql:latest

echo Waiting for container to start, sleeping 60 sec
sleep 60

echo Loading SQL data
docker exec -it mysql sh load-data.sh

echo Inventory database should be setup in container with 12 rows

sleep 3

echo Changing to ~/ibm-cloud-architecture/refarch-cloudnative-micro-inventory
cd ~/ibm-cloud-architecture/refarch-cloudnative-micro-inventory

echo Running cloudnative/inventory service, listening on port 8080
docker run -d -p 8080:8080 -e "spring.datasource.url=jdbc:mysql://172.17.0.2:3306/inventorydb" -e "spring.datasource.username=dbuser" -e "spring.datasource.password=password" -e "eureka_client_serviceUrl_defaultZone=http://172.17.0.5:8761/eureka" cloudnative/inventoryservice

# Note, I changed the code to have it listen on port 8081 by default, but, we could have mapped outside:inside like we did for zuul
echo Running cloudnative/socialreview service, listening on port 8081
docker run -d -p 8081:8081 --name socialreview -e "eureka_client_serviceUrl_defaultZone=http://172.17.0.5:8761/eureka" cloudnative/socialreviewservice

docker run --name netflix-zuul -p 8082:8080 -e "eureka_client_serviceUrl_defaultZone=http://172.17.0.5:8761/eureka" -d netflix-zuul:latest

