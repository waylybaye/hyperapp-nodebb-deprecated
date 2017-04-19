if ! [ -f $NODEBB_SRC/config.json ]; then;
  echo {\
    "url": "$URL"\
    "secret": "`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 36 | head -n 1`",\
    "database": "mongo",\
    "port": "$PORT",\
    "mongo": {\
      "host": "$MONGO_HOST",\
      "port": "$MONGO_PORT",\
      "database": "$DATABASE",\
    }\
  }\
  /opt/nodebb/nodebb setup
fi

exec "$@"
