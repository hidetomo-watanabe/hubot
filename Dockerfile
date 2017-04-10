FROM node
MAINTAINER hidetomo

# install
RUN npm install -g yo generator-hubot
RUN npm list -g yo generator-hubot

# user
RUN useradd hidetomo
RUN mkdir /home/hidetomo && chown hidetomo:hidetomo /home/hidetomo
USER hidetomo
WORKDIR /home/hidetomo

# create
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
