FROM node
MAINTAINER hidetomo

# install hubot
RUN npm install -g yo generator-hubot
RUN npm list -g yo generator-hubot

# create user
RUN useradd hidetomo
RUN mkdir /home/hidetomo && chown hidetomo:hidetomo /home/hidetomo

# change dir
WORKDIR /home/hidetomo

# create hubot
RUN su - hidetomo && \
  yo hubot --owner "hidetomo" --name "XXX-bot" --description "XXX-bot" --adapter slack

# copy
COPY restart_bot.sh hubot/restart_bot.sh
RUN tr \\r \\n <hubot/restart_bot.sh> tmp && mv tmp hubot/restart_bot.sh
RUN chown hidetomo:hidetomo hubot/restart_bot.sh
COPY monitoring.sh hubot/monitoring.sh
RUN tr \\r \\n <hubot/monitoring.sh> tmp && mv tmp hubot/monitoring.sh
RUN chown hidetomo:hidetomo hubot/monitoring.sh
COPY docker/start.sh start.sh
RUN tr \\r \\n <start.sh> tmp && mv tmp start.sh
RUN chown hidetomo:hidetomo start.sh

# change user
USER hidetomo

# start
CMD ["/bin/bash", "./start.sh"]
