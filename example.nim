import options, asyncdispatch
import std/tables

import nimpy
import httpbeast

import limdb

import times, schedules

type GatewaySettings = ref object of PyNimObjectExperimental
  schema: ref Table[string, string]

proc newGateway(db_path: string): GatewaySettings {.exportpy.}  =
  return GatewaySettings(schema: newTable[string, string]())
  # self.schema = newTable[string, string]()

# proc addEndpoint(self: GatewaySettings, endpoint: string, redirect: string) {.exportpy.} =
#     self.schema[endpoint] = redirect

# proc delEndpoint(self: GatewaySettings, endpoint: string) {.exportpy.} =
#     self.schema.del(endpoint)

# proc getRedirect(self: GatewaySettings, endpoint: string): string =
#     return self.schema.getOrDefault(endpoint)

# proc hasRedirect(self: GatewaySettings, endpoint: string): bool {.exportpy.} =
#   return self.schema.hasKey(endpoint)

proc tableFromDB(db: Database): TableRef[string, string] =
  var schema = newTable[string, string]()

  for key, value in db:
    schema[key] = value

  return schema

proc start(self: GatewaySettings, address: string, port: int, threads: int, db_path: string): void {.exportpy.} =

  let settings = initSettings(port=Port(port), bindAddr=address, numThreads=threads)

  let db = initDatabase(db_path)

  # This is the schema that we use in the onRequest function
  var schema = tableFromDB(db)

  # Create a scheduler that will load all keys from the database and add them to a table which we can read from.
  scheduler schemaUpdater:
    every(seconds=1, id="schema updater", async=true):
      schema = tableFromDB(db)

  proc onRequest(req: Request): Future[void] = 
    echo schema
    
    if schema.hasKey(req.path.get()):
      req.send($schema[req.path.get()])
    else:
      req.send(Http404)

  asyncCheck schemaUpdater.start()

  run(onRequest, settings)