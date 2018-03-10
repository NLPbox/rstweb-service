# WARNING: DO NOT USE THIS CONTAINER IN PRODUCTION, IT IS INSECURE!
#
# This container will start the 'local' version of rstWeb,
# which doesn't use any authentication. You can use it on your local
# machine, e.g. to work with the rst-workbench, but you shouldn't
# run it on a publicly reachalble server if you store any 'valualble'
# data in rstWeb.

FROM nlpbox/nlpbox-base:16.04

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install python-pip phantomjs apache2 elinks -y && \
    pip2 install cherrypy selenium

# Instead of Amir Zeldes' original repo, we will use
# the 'rst-workbench' branch of my fork, which adds a simple REST
# API for im/exporting rs3 files.
WORKDIR /opt
RUN git clone https://github.com/arne-cl/rstWeb.git && \
    mv rstWeb rstweb

WORKDIR /opt/rstweb
RUN git checkout rst-workbench

# start_local.py is not intended to be run as a server, so we have to change
# its IP address to make it work inside a docker container.
WORKDIR /opt/rstweb
RUN head -n -1 start_local.py > start_local_docker.py && \
    echo "cherrypy.server.socket_host = '0.0.0.0'" >> start_local_docker.py && \
    echo "cherrypy.quickstart(Root(), '/', conf)" >> start_local_docker.py

EXPOSE 8080
ENTRYPOINT ["python"]
CMD ["start_local_docker.py"]
