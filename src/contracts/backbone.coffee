#needs to be compiled with contracts.coffee to generate contract code!
#load contracts
root = exports ? this

C = root['contracts-js']
#our own little library for managing big libraries such as backbone
Contracted = root['contracted']
Backbone = root['Backbone']

makeObjChecker = (prop,obj,label)->
  C.check(((e)->
    e isnt null && typeof e is 'object' && e[prop] is obj),label)

#custom checks
Obj = C.check(((e)->
  e isnt null && typeof e == 'object'),"Object")
Arr = C.check(((e)->
  e isnt null && typeof e.length == 'number'))
Model       = makeObjChecker('__proto__',Backbone.Model.prototype,"Model")
View        = makeObjChecker('__proto__',Backbone.View.prototype,"View")
Collection  = makeObjChecker('__proto__',Backbone.Collection.prototype,"Collection")

#declare contracts here
backbone = new Contracted.ContractedLibrary("Backbone")

events = {}
events['on']          = ?(Any, (Any) -> Any) -> Any
events['off']         = ?(Str,(Any) -> Any) -> Any
events['trigger']     = ?(Str,Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['unbind']      = ?(Str,(Any) -> Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['listenTo']    = ?(Obj,Str,(Any) -> Any) -> Any

events_interface = new Contracted.Interface(backbone)
events_interface.contracts(events)

view_class = new Contracted.Class(backbone,Backbone.View.prototype)
view_class.implements(events_interface)

#set the library as exported means: guard everything with the correct label
backbone.export()
