FROM ubuntu:22.04
FROM python:3.7.12-bullseye

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN export LC_ALL="en_US.UTF-8"
RUN export LANG="en_US.UTF-8"

RUN apt-get update && apt-get upgrade -y
RUN apt -y install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
    && nvm install 16 \
    && nvm use 16 \
    && npm install -g yarn

RUN pip install semver==2.13.0
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN apt-get clean
RUN apt-get update
RUN apt-get -f install
RUN apt install hugo -y

WORKDIR /app

COPY . .
RUN chmod +x site.sh dump-docs-packages-metadata.py

RUN . "$HOME/.nvm/nvm.sh" && ./site.sh check-site-links && ./site.sh build-site 
#&& ./site.sh preview-landing-pages

CMD ["/bin/sh", "-c", ". \"$HOME/.nvm/nvm.sh\" && chmod +x site.sh dump-docs-packages-metadata.py && ./site.sh preview-landing-pages"]
# CMD ["/bin/bash"]
EXPOSE 3000