
echo "Starting eureka"
docker start netflix-eureka

sleep 45

echo "Starting config server"
docker start  spring-config

sleep 45

echo "Starting entree service"
docker start entree

echo "Starting appetizer service"
docker start appetizer

echo "Starting dessert service"
docker start dessert

echo "Starting menu service"
docker start menu 

echo "Starting menu ui"
docker start wfd-ui

echo "Starting Hystrix Dashboard and Netflix Turbine"
docker start netflix-turbine
docker start netflix-hystrix
docker start netflix-zuul
