echo Sending POST data to http://172.17.0.4:8081/micro/review
curl -H "Content-Type: application/json" -X POST -d '{ "comment": "Needs better instructions", "itemId": 13402, "rating": 5, "reviewer_email": "dbellagio@us.ibm.com", "reviewer_name": "Dave Bellagio", "review_date": "11/04/2016" }' http://172.17.0.4:8081/micro/review
