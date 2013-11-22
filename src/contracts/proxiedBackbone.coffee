root = exports ? this

backbone =  root['Backbone']
C        =  root['contracts-js']


Silencable = ? {
  silent: Bool
}

Arr = ? {
  length: !(x)-> typeof x is "number"
}

ArrChecker = (type)->
  t_contract = ?!(x)-> x instanceof type
  arr_contract = ?t_contract and Arr



Obj         = ?!(x)-> x isnt null and typeof x is 'object'
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




Collection_prototype = ? {
  model: Any
  models: Any
  colection: Model
  length: Num

  comparator: (Model,Model?)->Any

  add: (Model or Arr, Obj?) -> Any
  at: (Num)-> Model
  get: (Any)-> Model
  create: (Any, Any)-> Model
  pluk: (Str)-> Any
  pop: (Silencable?)-> Model
  remove: (Model or Arr, Silencable?)-> Model or Arr
  reset:  (Arr,Silencable?)-> Model
  shift:  (Silencable?)-> Model
  sort:   (Silencable?)-> Collection
  unshift: (Model,Any)-> Model
  where: (Any)-> Arr
  #mixins from underscore
  #todo: generalise
  all:        (((Model,Num)->Bool),Any?)->Bool
  any:        (((Model,Num)->Bool),Any?)->Bool
  collect:    (((Model,Num,Any?)->Arr),Any?)->Arr
  chain:      ()-> Any
  compact:    ()-> Arr
  contains:   (Any)->Bool
  countBy:    (Str or (Model,Num)->Any)-> Arr
  detect:     (((Any)->Bool),Any?)-> Any
  difference: (Arr)->Arr
  drop:       (Num?)-> Model or Arr
  each:       (Model,Num,Any?)->Any
  every:      (((Model,Num)->Bool),Any?)->Bool
  filter:     (((Model,Num)->Bool),Any?)->Arr
  find:       (((Model,Num)->Bool),Any?)->Model
  first:      (Num?)->Model or Arr
  flatten:    (Bool?)-> Arr
  foldl:      (((Any,Model,Num)->Any),Any,Any?)->Any
  forEach:    (((Model,Num,Any?)->Any),Any?)->Any
  include:    (Any)->Bool
  indexOf:    (Model,Bool?)->Num
  initial:    (Num?)->Model or Arr
  inject:     (((Any,Model,Num)->Any),Any,Any?)->Any
  intersection: (Arr)->Arr
  isEmpty:     (Any)->Bool
  invoke:     (Str,Arr)->Any
  last:       (Num?)->Model or Arr
  lastIndexOf:(Model,Num?)->Num
  map:        (((Model,Num,Any?)->Arr),Any?)->Arr
  max:        (((Model,Num,Any?)->Any)?,Any?)->Model
  min:        (((Model,Num,Any?)->Any)?,Any?)->Model
  object:     (Arr)->Arr
  reduce:     (((Any,Model,Num)->Any),Any,Any?)->Any
  select:     (Any,Any?)->Arr
  size:       ()->Num
  shuffle:    ()->Arr
  some:       (((Model,Num)->Any),Any?)->Bool
  sortBy:     ((Str or ((Model,Num)->Num)),Any?)->Arr
  sortedIndex:(Model,((Model,Num)->Num)?)->Num
  range:      (Num,Num?,Num?)->Any
  #wat nu? kan alleen als laatste twee optional zijn :)
  #range(stop: number, step?: number): any;
  #range(start: number, stop: number, step?: number): any;
  reduceRight:(((Any,Model,Num)->Any),Any,Any?)->Arr
  reject:     (((Model,Num)->Bool),Any?)->Arr
  #deze gaan wel werken maar ze zijn te "weak"
  #we maken de één optioneel en de andere dan met or
  rest:       (Num?)->Model or Arr
  tail:       (Num?)->Model or Arr
  toArray:    ()->Arr
  union:      (Arr)->Arr
  uniq:       (Bool?,((Model,Num)->Bool)?)->Arr
  without:    (Arr)->Arr
  zip:        (Arr)->Arr
}

copyProps = (obj)->
  result = {}
  for own prop of obj
    result[prop] = obj[prop]
  result

copyAndProxyPrototype = (orig,contract,constructor)->
  result = copyProps(orig)
  result :: contract
  result = result
  result.constructor = constructor
  return result

proxy.View.prototype  = copyAndProxyPrototype(backbone.View.prototype, View_prototype, backbone.View)
proxy.Model.prototype = copyAndProxyPrototype(backbone.Model.prototype, Model_prototype, backbone.Model)


C.setExported proxy.View, "Backbone.View"
C.setExported proxy.Model, "Backbone.Model"

root['proxiedBackbone'] = proxy
