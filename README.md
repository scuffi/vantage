# vantage
Vantage is a superrrrr speedy Python Gateway API with speed in mind. Also provides Swagger docs &amp; Status monitoring

# Storage
Endpoints and redirect are stored in an LMDB file. This allows for us to use any language to edit the endpoints whilst the server is still running. This also allows us to have persistent endpoint storage, so if a gateway somehow goes down, spinning it straight back up will immediately take off from where it was. That being said, if you're not careful, or don't disable persisten storage in the Vantage client, when you start a gateway, it will read the preexisting endpoints, which may or may not be what you actually want. Nothing is stopping you from deleting these through the client itself, just a note to remember when developing and/or deploying.
