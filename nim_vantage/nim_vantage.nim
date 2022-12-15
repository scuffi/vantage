import options, asyncdispatch
import std/tables

import nimpy
import httpbeast

type Vantage = ref object
  schema: Table[string, string]

proc addEndpoint(self: Vantage, endpoint: string, redirect: string): void =
    self.schema[endpoint] = redirect

proc delEndpoint(self: Vantage, endpoint: string): void =
    self.schema.del(endpoint)

proc getRedirect(self: Vantage, endpoint: string): string =
    return self.schema.getOrDefault(endpoint)

# var
#   api = Vantage(schema: initTable[string, string]())

# api.addEndpoint("/", "myredirect.com/api/v1/help")
# api.addEndpoint("/api", "other_service.com/api/something")

proc onRequest(req: Request): Future[void] = 

  var
    schema = {"/": "mydomain.com/api"}.toTable
  
  if schema.hasKey(req.path.get()):
    req.send(schema[req.path.get()])
  else:
    req.send(Http404)

proc startAPI(): void {.exportpy.} =
  run(onRequest)
