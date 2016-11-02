# create group for Eureka
cd refarch-cloudnative-netflix-eureka/docker 
cf ic build -t registry.ng.bluemix.net/supercontainers/netflix-eureka:dev .
cd ~
cf ic group create --name netflix-eureka -p 8761 -m 512 --min 1 --max 2 --desired 1 registry.ng.bluemix.net/supercontainers/netflix-eureka:dev

# for debug - cf ic route map -n super-menu-eureka-dev -d mybluemix.net netflix-eureka

# create group for the config server
cd refarch-cloudnative-spring-config/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/spring-config:dev .
cd ~
cf ic group create --name spring-config -p 8888 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-springconfig-bx registry.ng.bluemix.net/supercontainers/spring-config:dev

# create group for aggregate services and pass in config server load balancer IP, config server has Eureka and everything else in it
# appetizer
cd refarch-cloudnative-wfd-appetizer/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/wfd-appetizer:dev .
cd ~
cf ic group create --name appetizer -p 8082 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-appetizer-bx registry.ng.bluemix.net/supercontainers/wfd-appetizer:dev

# dessert
cd refarch-cloudnative-wfd-dessert/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/wfd-dessert:dev .
cd ~
cf ic group create --name dessert -p 8083 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-dessert-bx registry.ng.bluemix.net/supercontainers/wfd-dessert:dev

# entree
cd refarch-cloudnative-wfd-entree/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/wfd-entree:dev .
cd ~
cf ic group create --name entree -p 8081 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-entree-bx registry.ng.bluemix.net/supercontainers/wfd-entree:dev

# create group for menu, pass in Eureka
cd refarch-cloudnative-wfd-menu/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/wfd-menu:dev .
cd ~
cf ic group create --name menu -p 8180 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-menu-bx registry.ng.bluemix.net/supercontainers/wfd-menu:dev

# create group for wfd-ui, pass in Eureka
cd refarch-cloudnative-wfd-ui/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/wfd-ui:dev .
cd ~
cf ic group create --name wfd-ui -p 8181 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-wfdui-bx registry.ng.bluemix.net/supercontainers/wfd-ui:dev

# create public route and map it
cf create-route dev -n super-menu-dev mybluemix.net
cf ic route map -n super-menu-dev -d mybluemix.net wfd-ui

# create group for turbine, pass in Eureka
cd ~/refarch-cloudnative-netflix-turbine/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/netflix-turbine:dev .
cd ~
cf ic group create --name netflix-turbine -p 8989 -m 512 --min 1 --max 2 --desired 1 --env-file ~/env-turbine-bx registry.ng.bluemix.net/supercontainers/netflix-turbine:dev

# create group for zuul, pass in Eureka
cd ~/refarch-cloudnative-netflix-zuul/docker
cf ic build -t registry.ng.bluemix.net/supercontainers/netflix-zuul:dev .
cd ~
cf ic group create --name netflix-zuul -p 8080 -m 256 --auto --min 1 --max 2 --desired 1 --env-file ~/env-zuul-bx registry.ng.bluemix.net/supercontainers/netflix-zuul:dev

# create a public route to eureka
# cf create-route dev -n super-eureka-dev mybluemix.net
# cf ic route map -n super-eureka-dev -d mybluemix.net netflix-eureka

# create a public route to zuul
cf create-route dev -n super-zuul-dev mybluemix.net
cf ic route map -n super-zuul-dev -d mybluemix.net netflix-zuul

# remove public route to Eureka after everything is OK
# cf ic route unmap -n super-eureka-dev -d mybluemix.net netflix-eureka
# cf ic route unmap -n super-turbine-dev -d mybluemix.net netflix-turbine
# cf ic route unmap -n super-menu-dev -d mybluemix.net wfd-ui
# cf ic route unmap -n super-zuul-dev -d mybluemix.net netflix-zuul

