FROM node
MAINTAINER hidetomo

# version
ARG pyVer=anaconda3-4.0.0
ARG pipVer=8.1.2

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
ENV HOME /home/hidetomo

# alias
RUN echo "alias ls='ls --color'" >> .bashrc

# common apt-get
RUN sudo apt-get -y install vim

# create dir
RUN mkdir /home/hidetomo/hubot
RUN mkdir /home/hidetomo/hubot/data
RUN mkdir /home/hidetomo/hubot/scripts_tmp

# copy hubot files
WORKDIR /home/hidetomo/hubot
COPY package.json package.json_tmp
RUN sudo chown hidetomo:hidetomo package.json_tmp
COPY external-scripts.json external-scripts.json_tmp
RUN sudo chown hidetomo:hidetomo external-scripts.json_tmp
COPY scripts scripts_tmp/
RUN sudo chown hidetomo:hidetomo scripts_tmp/*
COPY restart_bot.sh restart_bot.sh
RUN sudo chown hidetomo:hidetomo restart_bot.sh
COPY data/slack_token data/slack_token
RUN sudo chown hidetomo:hidetomo data/slack_token
WORKDIR /home/hidetomo

# create hubot
WORKDIR /home/hidetomo/hubot
RUN yo hubot --owner "hidetomo" --name "XXX-bot" --description "XXX-bot" --adapter slack
RUN mv package.json_tmp package.json
RUN sudo npm install
RUN mv external-scripts.json_tmp external-scripts.json
RUN mv scripts_tmp/* scripts/
RUN rmdir scripts_tmp
WORKDIR /home/hidetomo

# cron
RUN sudo apt-get -y install cron
COPY cron.txt cron.txt
RUN sudo chown hidetomo:hidetomo cron.txt
COPY monitoring.sh monitoring.sh
RUN sudo chown hidetomo:hidetomo monitoring.sh
RUN crontab cron.txt

# pyenv
RUN git clone https://github.com/yyuu/pyenv.git .pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .bashrc
ENV PYENV_ROOT $HOME/.pyenv
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> .bashrc
ENV PATH $PYENV_ROOT/bin:$PATH
RUN echo 'eval "$(pyenv init -)"' >> .bashrc
RUN echo 'export PYTHONIOENCODING=utf-8' >> .bashrc

# anaconda
# RUN pyenv install -l | grep ana
RUN pyenv install ${pyVer}
RUN pyenv rehash
RUN pyenv global ${pyVer}
RUN echo 'export PATH="$PYENV_ROOT/versions/'${pyVer}'/bin/:$PATH"' >> .bashrc
ENV PATH $PYENV_ROOT/versions/${pyVer}/bin/:$PATH

# keras
RUN conda install -y pip=${pipVer}
RUN pip install tensorflow
RUN pip install keras

# start
COPY docker/start.sh start.sh
RUN sudo chown hidetomo:hidetomo start.sh
CMD ["/bin/bash", "/home/hidetomo/start.sh"]
