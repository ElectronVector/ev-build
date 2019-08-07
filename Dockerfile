FROM ubuntu:18.04

WORKDIR /app

RUN apt-get update && apt-get install -y ruby gcc
RUN gem install ceedling

