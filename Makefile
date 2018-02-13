docker-build:
	docker build --tag blusaphir-sandbox .

docker-create:
	docker create --tty --interactive --name blusaphir --volume C:\Users\jasew\workspace\blusaphir-sandbox:/blusaphir --publish 9000:9000 blusaphir-sandbox

docker-clean:
	docker stop blusaphir || echo "Blu Saphir not running" 
	docker rm blusaphir || echo "blu Saphir container does no exist"
	docker rmi blusaphir-sandbox