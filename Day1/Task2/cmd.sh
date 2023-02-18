#!/bin/bash
sudo python3 /home/ubuntu/app/manage.py makemigrations
sudo python3 /home/ubuntu/app/manage.py migrate
sudo python3 /home/ubuntu/app/manage.py runserver 0.0.0.0:8000