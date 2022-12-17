import options, asyncdispatch
import std/tables

import nimpy
import httpbeast

proc dummy(): string {.exportpy.} =
    return "dummy"

proc onReq(req: Request): Future[void] = 
    # var schema = {"/": "mydomain.com/api"}.toTable

    # if schema.hasKey(req.path.get()):
    #   req.send(schema[req.path.get()])
    # else:
    #   req.send(Http404)

  req.send("Hello world")


run(onReq)