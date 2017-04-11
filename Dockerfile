FROM node
MAINTAINER hidetomo

# install hubot
RUN npm install -g yo generator-hubot
RUN npm list -g yo generator-hubot

# create user
RUN useradd hidetomo
RUN mkdir /home/hidetomo && chown hidetomo:hidetomo /home/hidetomo

# create dir
USER hidetomo
RUN mkdir /home/hidetomo/hubot
RUN mkdir /home/hidetomo/hubot/data
WORKDIR /home/hidetomo/hubot
USER root

# copy
COPY pacakge.json package.json_tmp
RUN tr \\r \\n <package.json_tmp> tmp && mv tmp package.json_tmp
RUN chown hidetomo:hidetomo package.json_tmp
COPY restart_bot.sh restart_bot.sh
RUN tr \\r \\n <restart_bot.sh> tmp && mv tmp restart_bot.sh
RUN chown hidetomo:hidetomo restart_bot.sh
COPY monitoring.sh monitoring.sh
RUN tr \\r \\n <monitoring.sh> tmp && mv tmp monitoring.sh
RUN chown hidetomo:hidetomo monitoring.sh
COPY data/slack_token data/slack_token
RUN tr \\r \\n <data/slack_token> tmp && mv tmp data/slack_token
RUN chown hidetomo:hidetomo data/slack_token
WORKDIR /home/hidetomo
COPY docker/start.sh start.sh
RUN tr \\r \\n <start.sh> tmp && mv tmp start.sh
RUN chown hidetomo:hidetomo start.sh

# change user and dir
USER hidetomo
WORKDIR /home/hidetomo/hubot

# create hubot
RUN yo hubot --owner "hidetomo" --name "XXX-bot" --description "XXX-bot" --adapter slack
RUN mv package.json_tmp package.json
RUN npm install

# start command
CMD ["/bin/bash", "/home/hidetomo/start.sh"]
