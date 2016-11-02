cf ic group create --name entree -p 9080 -m 1024 --min 1 --max 2 --desired 1 --env-file env-entree registry.eu-gb.bluemix.net/rabobankpocms/wfd-entree:liberty
cf ic group create --name dessert -p 9080 -m 1024 --min 1 --max 2 --desired 1 --env-file env-dessert registry.eu-gb.bluemix.net/rabobankpocms/wfd-dessert:liberty
cf ic group create --name appetizer -p 9080 -m 1024 --min 1 --max 2 --desired 1 --env-file env-appetizer registry.eu-gb.bluemix.net/rabobankpocms/wfd-appetizer:liberty
cf ic group create --name menu -p 9080 -m 1024 --min 1 --max 2 --desired 1 --env-file env-menu registry.eu-gb.bluemix.net/rabobankpocms/wfd-menu:liberty
cf ic route map -n rabo-menu-sandbox -d eu-gb.mybluemix.net menu
