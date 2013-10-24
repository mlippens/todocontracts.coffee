#needs to be compiled with contracts.coffee to generate contract code!
#load contracts
C = window['contracts-js']

#custom checks
Obj= C.check(((e)->
  e != null && typeof e == 'object'),"Object")
Model= C.check((e)->
  e == null || e = null && e == 'object' && e.__proto__ == Backbone.Model.prototype)

events = {}

events['on']          = ?(Any, (Any) -> Any) -> Any
events['off']         = ?(Str,(Any) -> Any) -> Any
events['trigger']     = ?(Str,Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['unbind']      = ?(Str,(Any) -> Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['listenTo']    = ?(Obj,Str,(Any) -> Any) -> Any

view = {}
view['model']         = ?(Model)

for c of events
  do (contract = c)->
    guarded = C.guard(events[contract],Backbone.View.prototype[contract],"Backbone")
    Backbone.View.prototype[contract] = guarded
