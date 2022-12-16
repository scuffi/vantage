import options, asyncdispatch
import std/tables

import nimpy
import httpbeast

type GatewaySettings = ref object of PyNimObjectExperimental
  schema: Table[string, string]

proc initSettings(self: GatewaySettings) {.exportpy.}  =
  self.schema = initTable[string, string]()

proc addEndpoint(self: GatewaySettings, endpoint: string, redirect: string) {.exportpy.} =
    self.schema[endpoint] = redirect

proc delEndpoint(self: GatewaySettings, endpoint: string) {.exportpy.} =
    self.schema.del(endpoint)

proc getRedirect(self: GatewaySettings, endpoint: string): string =
    return self.schema.getOrDefault(endpoint)

proc hasRedirect(self: GatewaySettings, endpoint: string): bool {.exportpy.} =
  return self.schema.hasKey(endpoint)

# var
#   api = Vantage(schema: initTable[string, string]())

# api.addEndpoint("/", "myredirect.com/api/v1/help")
# api.addEndpoint("/api", "other_service.com/api/something")

# proc onRequest(req: Request): Future[void] = 

#   var
#     schema = {"/": "mydomain.com/api"}.toTable
  
#   if schema.hasKey(req.path.get()):
#     req.send(schema[req.path.get()])
#   else:
#     req.send(Http404)

proc startRunner(settings: GatewaySettings): void {.exportpy.} =
  proc onReq(req: Request): Future[void] = 
    if settings.hasRedirect(req.path.get()):
      req.send(settings.getRedirect(req.path.get()))
    else:
      req.send(Http404)

  run(onReq)
