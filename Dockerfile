FROM ubuntu

RUN apt-get update && apt-get -y install git vim unzip && git clone https://github.com/OpsTree/CloudAutomation.git && mkdir -p /usr/local/terraform
WORKDIR /CloudAutomation/terraform

RUN mkdir ~/.ssh && cp config ~/.ssh && cp prasad ~/.ssh/prasad.pem && chmod 600 ~/.ssh/prasad.pem 
WORKDIR /usr/local/terraform
ADD terraform_0.6.16_linux_amd64.zip /usr/local/terraform
RUN unzip terraform_0.6.16_linux_amd64.zip

WORKDIR /CloudAutomation/terraform

