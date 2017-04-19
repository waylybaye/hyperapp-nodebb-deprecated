FROM node:4-slim

ENV NODEBB_SRC /opt/nodebb
ENV UPLOAD_PATH /public/uploads
# ENV NODEBB_VERSION 0.11.7

ENV URL "http://localhost"
ENV DATABASE "mongo"
ENV MONGO_HOST = "mongo"
ENV MONGO_PORT = "27017"
ENV PORT 80

RUN groupadd -r nodebb \
&&  useradd -r -g nodebb nodebb \
&& mkdir $UPLOAD_PATH \
&& chown -R nodebb:nodebb $NODEBB_SRC \
&& chown -R nodebb:nodebb $UPLOAD_PATH


WORKDIR $NODEBB_SRC

RUN set -ex; \
	\
	buildDeps=' \
    git \
    build-essential \
	'; \
	apt-get update; \
	apt-get install -y $buildDeps --no-install-recommends; \
	rm -rf /var/lib/apt/lists/*; \
  cd $WORKDIR \
  git clone https://github.com/NodeBB/NodeBB.git . \
	npm install --production; \
	./nodebb build
	apt-get purge -y --auto-remove $buildDeps; \
	npm cache clean; \
	rm -rf /tmp/npm*

# # Ghost expects "config.js" to be in $GHOST_SOURCE, but it's more useful for
# # image users to manage that as part of their $GHOST_CONTENT volume, so we
# # symlink.
# 	&& ln -s "$GHOST_CONTENT/config.js" "$GHOST_SOURCE/config.js"

VOLUME $NODEBB_SRC
VOLUME $UPLOAD_PATH

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

USER nodebb
EXPOSE $PORT
CMD ["$NODEBB_SRC/nodebb", "start"]
