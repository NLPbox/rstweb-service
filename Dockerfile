# WARNING: DO NOT USE THIS CONTAINER IN PRODUCTION, IT IS INSECURE!
#
# This container will start the 'local' version of rstWeb,
# which doesn't use any authentication. You can use it on your local
# machine, e.g. to work with the rst-workbench, but you shouldn't
# run it on a publicly reachalble server if you store any 'valualble'
# data in rstWeb.

FROM ubuntu:18.04

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install git python-pip phantomjs elinks -y && \
    pip2 install cherrypy routes selenium pexpect pytest requests imagehash

# Instead of Amir Zeldes' original repo, we will use
# the 'add-rest-api' branch of my fork, which adds a simple REST
# API for im/exporting/converting rs3 files.
WORKDIR /opt
RUN git clone https://github.com/arne-cl/rstWeb.git && \
    mv rstWeb rstweb && echo 1

WORKDIR /opt/rstweb
#RUN git checkout add-rest-api
RUN git checkout rst-workbench-3.0.1

# start_local.py is not intended to be run as a server, so we have to change
# its IP address to make it work inside a docker container.
WORKDIR /opt/rstweb
RUN sed 's/import cherrypy$/import cherrypy; cherrypy.server.socket_host = "0.0.0.0"/g' start_local.py >> start_local_docker.py

# TODO: remove after debug
RUN pip2 install pudb ipython

EXPOSE 8080
ENTRYPOINT ["python"]
CMD ["start_local_docker.py"]
