root = exports ? this

backbone =  root['Backbone']
C        =  root['contracts-js']


Silencable = ? {
  silent: Bool
}

Arr = ? {
  length: !(x)-> typeof x is "number"
}

Obj         = ?! (x)-> x isnt null and typeof x is 'object'
Model       = ?!(x)-> x instanceof Backbone.Model
View        = ?!(x)-> x instanceof Backbone.View
Router      = ?!(x)-> x instanceof Backbone.Router
Collection  = ?!(x)-> x instanceof Backbone.Collection
Events      = ?!(x)-> x instanceof Backbone.Events
History     = ?!(x)-> x instanceof Backbone.History

Constructor = ?(Any) ==> Any
Extend      = ?(Any)-> Any



events = {}
events['on']          = ?(Any, (Any) -> Any) -> Any
events['off']         = ?(Str,(Any) -> Any) -> Any
events['trigger']     = ?(Str,Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['unbind']      = ?(Str,(Any) -> Any) -> Any
events['listenTo']    = ?(Obj,Str,(Any) -> Any) -> Any


proxy ::
  VERSION:    Str
  View:       !Constructor
  Model:      !Constructor
  Router:     !Constructor
  Collection: !Constructor
  Events:     !Constructor
  History:    !Constructor
proxy =
  VERSION:    backbone.VERSION
  View:       backbone.View.bind({})
  Model:      backbone.Model.bind({})
  Router:     backbone.Router.bind({})
  Collection: backbone.Router.bind({})
  Events:     backbone.Events.bind({})
  History:    backbone.History.bind({})

View_prototype = ? {
  on:                 !events['on']
  off:                !events['off']
  trigger:            !events['trigger']
  bind:               !events['on']
  unbind:             !events['off']
  listenTo:           !events['listenTo']
  tagName:            Str
  initialize:         (Any) -> Any
  $:                  (Str)-> Any
  setElement:         (Any, Bool) -> Any
  render:             (Any) -> Any
  remove:             (Any) -> Any
  delegateEvents:     (Any) -> Any
  undelegateEvents:   (Any) -> Any
}


Model_prototype = ? {
  bind:         !events['on']
  unbind:       !events['off']
  on:           !events['on']
  off:          !events['off']
  trigger:      !events['trigger']
  listenTo:     !events['listenTo']

  idAttribute:  Str
  changed:      Null or Arr
  changedAttributes: (Any)-> Arr
  clear:        (Silencable?) -> Any
  clone:        () -> Any
  destroy:      (Obj?) -> Any
  escape:       (Str) -> Str
  get:          (Str) -> Any
  has:          (Str) -> Bool
  hasChanged:   (Str?)-> Bool
  isNew:        ()-> Bool
  isValid:      ()-> Bool
  previous:     (Str)-> Bool
  previousAttributes: ()-> Arr
  set:          (Any) -> Any #mult options?
  save:         (Any,Obj)->Any
  unset:        (Str,Silencable?)-> Obj
  url:          Any
  parse:        (Any,Any)->Any
  toJSON:       (Any)->Any
  sync:         (Arr)->Any
}

copyProps = (obj)->
  result = {}
  for own prop of obj
    result[prop] = obj[prop]
  result

copyAndGuardPrototype = (orig,contract,constructor)->
  result = copyProps(orig)
  result :: contract
  result = result
  result.constructor = constructor
  return result

proxy.View.prototype  = copyAndGuardPrototype(backbone.View.prototype, View_prototype, backbone.View)
proxy.Model.prototype = copyAndGuardPrototype(backbone.Model.prototype, Model_prototype, backbone.Model)


C.setExported proxy.View, "Backbone.View"
C.setExported proxy.Model, "Backbone.Model"

root['proxiedBackbone'] = proxy
