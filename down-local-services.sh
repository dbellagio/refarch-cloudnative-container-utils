echo "Stopping Hystrix Dashboard and Netflix turbine"
docker stop netflix-turbine

echo "Stopping menu service"
docker stop menu 

echo "Stopping menu ui"
docker stop wfd-ui

echo "Stopping entree service"
docker stop entree

echo "Stopping appetizer service"
docker stop appetizer

echo "Stopping dessert service"
docker stop dessert

echo "Stopping config server"
docker stop  configserver

echo "Stopping eureka"
docker stop eureka

