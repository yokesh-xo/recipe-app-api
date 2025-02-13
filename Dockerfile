# Docker Image
FROM python:3.9-alpine3.13  
# Specifies who manages the container
LABEL maintainer="yokesh03" 

# Tell the docker to not buffer the output on python to cmd
ENV PYTHONUNBUFFERED 1  

# Copies from local machine to /tmp file of Image
COPY ./requirements.txt /tmp/requirements.txt   
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Copies from local Machine to /app file of Image
COPY ./app /app 
# working directory where our py cmds are gonna run by default
WORKDIR /app
# expose container to port 8000 of local machine    
EXPOSE 8000 

# Runs a command on the alpine img that we are using

# create virtual env inside docker image
# upgrading py package manager inside venv
# install our requirements file which we copied
# install dev requirements file only when on dev env
# remove tmp directory as we don't need it anymore
# add new user inside image to avoid using root user, do not use root user for security
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV="true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# updating the PATH env variable in the image, when we run any py cmd it automatically runs on updated path
ENV PATH="/py/bin:$PATH"

# Switching to specified user from root user
USER django-user