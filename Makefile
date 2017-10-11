PW := pw
SERVER_IMAGE := mysql_server
DB_NAME := budget

.PHONY: all loader client

all: account.sql

server:
	docker ps | egrep ' ${SERVER_IMAGE}$$' || \
			docker run --env MYSQL_ROOT_PASSWORD=${PW} --volume ${PWD}/data:/var/lib/mysql --name ${SERVER_IMAGE} --detach mysql && echo "Giving mysqld a few secs to start up... " && sleep 5 && echo "done.";

loader: server account.sql
	cat account.sql | \
			docker run -i --rm --link ${SERVER_IMAGE}:mysql -v ${PWD}:/app mysql \
			mysql -h mysql --password=${PW} ${DB_NAME}

client: loader
	docker run --rm -it --link ${SERVER_IMAGE}:mysql -v ${PWD}:/app mysql mysql --host mysql --password=${PW} ${DB_NAME}

shell:
	docker run --rm -it --link ${SERVER_IMAGE}:mysql -v ${PWD}:/app mysql bash

kill:
	docker stop ${SERVER_IMAGE} && docker rm ${SERVER_IMAGE}

account.sql: transactions.csv importer.pl
	perl ./importer.pl transactions.csv > account.sql
