FROM node
MAINTAINER hidetomo

# install hubot
RUN npm install -g yo generator-hubot
RUN npm list -g yo generator-hubot

# create user
RUN useradd hidetomo
RUN mkdir /home/hidetomo && chown hidetomo:hidetomo /home/hidetomo

# sudo
RUN yum -y install sudo
RUN echo "hidetomo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# change user and dir
USER hidetomo
WORKDIR /home/hidetomo

# create hubot
RUN yo hubot --owner "hidetomo" --name "XXX-bot" --description "XXX-bot" --adapter slack

# customize
COPY restart_bot.sh hubot/restart_bot.sh
RUN sudo tr \\r \\n <hubot/restart_bot.sh> tmp && sudo mv tmp hubot/restart_bot.sh
RUN sudo chown hidetomo:hidetomo hubot/restart_bot.sh
COPY monitoring.sh hubot/monitoring.sh
RUN sudo tr \\r \\n <hubot/monitoring.sh> tmp && sudo mv tmp hubot/monitoring.sh
RUN sudo chown hidetomo:hidetomo hubot/monitoring.sh

# start
COPY docker/start.sh start.sh
RUN sudo tr \\r \\n <start.sh> tmp && sudo mv tmp start.sh
RUN sudo chown hidetomo:hidetomo start.sh
CMD ["/bin/bash", "./start.sh"]
