# Adding a new page with python
curl -u YOURID:YOURPASSWORD -X POST -H 'Content-Type: application/json' -d'{"type":"page","title":"new page","space":{"key":"TEST"},"body":{"storage":{"value":"<p>This is a new page</p>","representation":"storage"}}}' http://desktop:8090/rest/api/content/ | python -mjson.tool
