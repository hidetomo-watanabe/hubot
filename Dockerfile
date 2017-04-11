FROM node
MAINTAINER hidetomo

# create user
RUN useradd hidetomo
RUN mkdir /home/hidetomo && chown hidetomo:hidetomo /home/hidetomo

# sudo
RUN apt-get -y update
RUN apt-get -y install sudo
RUN echo "hidetomo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install hubot
RUN npm install -g yo generator-hubot
RUN npm list -g yo generator-hubot

# change user and dir
USER hidetomo
WORKDIR /home/hidetomo

# create dir
RUN mkdir /home/hidetomo/hubot
RUN mkdir /home/hidetomo/hubot/data

# copy
WORKDIR /home/hidetomo/hubot
COPY package.json package.json_tmp
RUN sudo chown hidetomo:hidetomo package.json_tmp
RUN tr \\r \\n <package.json_tmp> tmp && mv tmp package.json_tmp
COPY external-scripts.json external-scripts.json_tmp
RUN sudo chown hidetomo:hidetomo external-scripts.json_tmp
RUN tr \\r \\n <external-scripts.json_tmp> tmp && mv tmp external-scripts.json_tmp
COPY restart_bot.sh restart_bot.sh
RUN sudo chown hidetomo:hidetomo restart_bot.sh
RUN tr \\r \\n <restart_bot.sh> tmp && mv tmp restart_bot.sh
COPY monitoring.sh monitoring.sh
RUN sudo chown hidetomo:hidetomo monitoring.sh
RUN tr \\r \\n <monitoring.sh> tmp && mv tmp monitoring.sh
COPY data/slack_token data/slack_token
RUN sudo chown hidetomo:hidetomo data/slack_token
RUN tr \\r \\n <data/slack_token> tmp && mv tmp data/slack_token
WORKDIR /home/hidetomo
COPY docker/start.sh start.sh
RUN sudo chown hidetomo:hidetomo start.sh
RUN tr \\r \\n <start.sh> tmp && mv tmp start.sh

# create hubot
WORKDIR /home/hidetomo/hubot
RUN yo hubot --owner "hidetomo" --name "XXX-bot" --description "XXX-bot" --adapter slack
RUN mv package.json_tmp package.json
RUN sudo npm install
RUN mv external-scripts.json_tmp external-scripts.json
WORKDIR /home/hidetomo

# start command
CMD ["/bin/bash", "/home/hidetomo/start.sh"]
