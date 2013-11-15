Class = class Interface

  contracts = if Map then new Map else {}
  keys = []
  contractedObject = null

  constructor: (root,contractedObj)->
    contractedObject = contractedObj
    ###if typeof root isnt 'undefined'
      root.add(@)###

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

  __keys: ()->
    keys

  __get: (key)->
    contracts.get key

  guard: ()->
    if contractedObject isnt null
      for key in keys
        do (k = key)->
          contract = contracts.get k
          if contract?
            guarded = C.guard(contract,contractedObject[k])
            contractedObject[k] = guarded

g = new Class()

g.contracts
  ali_g: "hello guys!"

f = new Class()
f.extend g,
  foo: "hi"
  boo: "ho"
  bee: "he"



alert f.__keys()