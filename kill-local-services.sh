echo "Stopping zuul"
docker stop netflix-zuul
docker rm netflix-zuul

echo "Stopping Hystrix Dashboard and Turbine"
docker stop netflix-turbine
docker rm netflix-turbine

echo "Stopping menu service"
docker stop menu 
docker rm menu 

echo "Stopping menu ui"
docker stop wfd-ui
docker rm wfd-ui

echo "Stopping entree service"
docker stop entree
docker rm entree

echo "Stopping appetizer service"
docker stop appetizer
docker rm appetizer

echo "Stopping dessert service"
docker stop dessert
docker rm dessert

echo "Stopping config server"
docker stop  configserver
docker rm  configserver

echo "Stopping eureka"
docker stop netflix-eureka
docker rm netflix-eureka

