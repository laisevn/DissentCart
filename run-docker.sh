#!/bin/bash

sudo docker-compose up -d db redis redis-gui

sleep 10

sudo docker-compose run web rails db:create
sudo docker-compose run web rails db:migrate
sudo docker-compose run web rails db:test:prepare

sudo docker-compose up
