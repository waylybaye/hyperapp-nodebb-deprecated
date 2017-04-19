# hyperapp-nodebb

HyperApp is an SSH Terminal and Docker Automation iOS App.

NodeBB is a popular open source forum runs on node.js.


## How to use this image

First, start an instance of mongo:

```bash
docker run --name db -d mongo:3.2 mongod --smallfiles
```

Then start NodeBB linked to this mongo instance:

```bash
docker run -d -v /srv/docker/nodebb/uploads:/public/uploads\
           -p 80:80
           --link mongod:mongo\
           -e URL=https://domain.com
```

Now, visit http://domain.com in the browser!
