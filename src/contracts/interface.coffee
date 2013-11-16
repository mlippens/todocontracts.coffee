root = exports ? this
C = root['contracts-js']

class ContractedLibrary

  moduleName = ""
  exportedObjects = []

  constructor: (name)->
    moduleName = new ModuleName(name,"",false)

  add: (obj)->
    exportedObjects.push obj

  export: ()->
    for obj in exportedObjects
      obj.export(moduleName)


Class = class Interface

  contracts = if Map then new Map else {}
  keys = []
  contractedObject = null

  guard = ()->
    if contractedObject isnt null
      for key in keys
        do (k = key)->
          contract = contracts.get k
          if contract?
            guarded = C.guard(contract,contractedObject[k])
            contractedObject[k] = guarded

  constructor: (lib,contractedObj)->
    contractedObject = contractedObj
    lib.add(@)


  extend: (extended,obj)->
    #put the contracts in your own map
    for own contract of obj
      mapval = contracts.get contract
      if not mapval?
        contracts.set contract, obj[contract]
        keys.push contract
    #put the extended object's keys in your map
    if extended isnt null and typeof extended is 'object' and extended.__keys?
      keys = extended.__keys()
      for key in keys
        value = contracts.get key
        if not value?
          contracts.set key,value

  implements: (a,b)->
    @extend(a,b)

  contracts: (object)->
    @extend(null,object)

  isInterface: ()->
    return (contractedObject is null)

  __keys: ()->
    keys

  __get: (key)->
    contracts.get key

  export: (moduleName)->
    if not @isInterface()
      guard()
      C.setExported(contractedObject,moduleName)
    return true


r = new ContractedLibrary("Backbone")
g = new Class(r)

g.contracts
  ali_g: "hello guys!"

f = new Class(r)
f.extend g,
  foo: "hi"
  boo: "ho"
  bee: "he"



alert f.__keys()