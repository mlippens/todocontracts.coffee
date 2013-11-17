root = exports ? this
C = root['contracts-js']

#global vars to mainstream things.
library_path = 'libraries'
exports = root.contracted = {}

class ContractedLibrary

  module = ""
  exportedObjects = []

  constructor: (name)->
    module = name

  add: (obj)->
    exportedObjects.push obj

  each: (fun)->
    for obj in exportedObjects
      if not obj.isInterface()
        fun.call(@,obj)

  export: ()->
    moduleName = new ModuleName(module,"",false)
    for obj in exportedObjects
      obj.export(moduleName)
    #we store this object somewhere so we can access it in a module that exports it.
    #the moduleName here should be the same as the one we registered with require.js!
    #in the wrapper we can then check whether the library is known in our own contract system.
    exports[library_path][module] = @


Interface = class Class

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


define = (name, deps, callback)->
  if typeof define is 'function' and define.amd
      if typeof name isnt 'string'
        cb = deps
      else
        cb = callback

      #big difference here: we dont call the callback with
      #the object, but rather with the original arguments array sliced.
      wrapped_callback = ()->
        i = 0
        while i < arguments.length
          lib = deps[i]
          if exports[library_path][lib]
            contracted_module = exports[library_path][lib]
            contracted_module.each (e)->
              C.use e,name
          else
            C.use arguments[i], name
          i++
        slice = {}.slice
        ret = cb.call(@,slice.call(arguments,0))
        C.setExported ret,name

      if(not Array.isArray(deps))
        deps = wrapped_callback
      define(name,deps,wrapped_callback)


 ###
  module shim originating from nodes.coffee in contracts.coffee
    if (typeof(define) === 'function' && define.amd) {
      // we're using requirejs

      // Allow for anonymous functions
      __define = function(name, deps, callback) {
        var cb, wrapped_callback;

      if(typeof(name) !== 'string') {
      cb = deps;
      } else {
    cb = callback;
      }


      wrapped_callback = function() {
      var i, ret, used_arguments = [];
      for (i = 0; i < arguments.length; i++) {
    used_arguments[i] = __contracts.use(arguments[i], "#{o.filename}");
      }
      ret = cb.apply(this, used_arguments);
      return __contracts.setExported(ret, "#{o.filename}");
      };

      if(!Array.isArray(deps)) {
      deps = wrapped_callback;
      }
      define(name, deps, wrapped_callback);
      };
    }###

exports.Class = Class
exports.Interface = Interface
exports.ContractedLibrary = ContractedLibrary
exports.define = define

return exports


###
r = new ContractedLibrary("Backbone")
g = new Class(r)

g.contracts
  ali_g: "hello guys!"

f = new Class(r)
f.extend g,
  foo: "hi"
  boo: "ho"
  bee: "he"

alert f.__keys()###
