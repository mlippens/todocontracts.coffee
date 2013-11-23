root = exports ? this

backbone =  root['Backbone']
C        =  root['contracts-js']


Silencable = ? {
  silent: Bool
}
NavigateOptions = ? {
  trigger: Bool
}
HistoryOptions = ? {
  pushState: Bool?
  root:      Str?
}

Arr = ? {
  length: !(x)-> typeof x is "number"
}


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
events['on']          = ?(Str, ((Any?) -> Any?)?,Any?) -> Any
events['off']         = ?(Str?,((Any?) -> Any?)?,Any?) -> Any
events['trigger']     = ?(Str,Arr) -> Any
#identical to on and off just aliases
###events['bind']        = ?(Str,(Any) -> Any) -> Any
events['unbind']      = ?(Str,(Any) -> Any) -> Any###
events['listenTo']    = ?(Obj,Str,(Any?) -> Any) -> Any
#events['listenToOnce']= ?(Obj,Str,(Any?) -> Any)-> Any
events['stopListening']=?(Obj?,Str?,((Any?)->Any)?)->Any
events['once']        =?(Str,((Any?)->Any),Any?)->Any


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

Router_prototype = ? {
  route:      (Str,Str,((Any?)->Any?)?)->Any
  navigate:   (Str,Bool or NavigateOptions)-> Router
}

History_prototype = ? {
  _updateHash:  (Any,Str,Bool)->Any

  bind:         !events['on']
  checkUrl:     (Any?)->Any
  getFragment:  (Str,Bool?)->Str
  getHash:      (Any?)-> Str
  interval:     Num
  listenTo:     !events['listenTo']
  loadUrl:      (Str)->Bool
  navigate:     (Str,Any?)->Bool
  on:           !events['on']
  off:          !events['off']
  once:         !events['once']
  route:        (Str,((Any?)->Any)?)->Any
  start:        (HistoryOptions?)-> Bool
  stop:         ()->Any
  stopListening:!events['stopListening']
  trigger:      !events['trigger']
  unbind:       !events['off']
  #started:      Bool
}

View_prototype = ? {
  on:                 !events['on']
  off:                !events['off']
  trigger:            !events['trigger']
  bind:               !events['on']
  unbind:             !events['off']
  listenTo:           !events['listenTo']
  stopListening:      !events['stopListening']

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
  on:                 !events['on']
  off:                !events['off']
  trigger:            !events['trigger']
  bind:               !events['on']
  unbind:             !events['off']
  listenTo:           !events['listenTo']
  stopListening:      !events['stopListening']

  idAttribute:  Str
  changed:      Null or Arr
  changedAttributes: (Any?)-> Arr
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
  save:         (Any?,Any?)->Any
  unset:        (Str,Silencable?)-> Obj
  url:          Any
  parse:        (Any,Any?)->Any
  toJSON:       (Any?)->Any
  sync:         (Arr)->Any

###  #underscore mixins
  keys:         ()->[...Str]
  values:       ()->[...Any]
  pairs:        ()->[...Any]
  invert:       ()->Any
  pick:         ([...Str])->Any
  omit:         ([...Str])->Any###
}

Collection_prototype = ? {
  model: Any
  models: Any
  collection: Model
  length: Num

  #fetch
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
  compact:    ()-> [...Model]
  contains:   (Any)->Bool
  countBy:    (Str or (Model,Num)->Any)-> Arr
  detect:     (((Any)->Bool),Any?)-> Any
  difference: ([...Model])->[...Model]
  drop:       (Num?)-> Model or [...Model]
  each:       (Model,Num,Any?)->Any
  every:      (((Model,Num)->Bool),Any?)->Bool
  filter:     (((Model,Num)->Bool),Any?)->[...Model]
  find:       (((Model,Num)->Bool),Any?)->Model
  first:      (Num?)->Model or [...Model]
  flatten:    (Bool?)-> [...Model]
  foldl:      (((Any,Model,Num)->Any),Any,Any?)->Any
  forEach:    (((Model,Num,Any?)->Any),Any?)->Any
  include:    (Any)->Bool
  indexOf:    (Model,Bool?)->Num
  initial:    (Num?)->Model or [...Model]
  inject:     (((Any,Model,Num)->Any),Any,Any?)->Any
  intersection: ([...Model])->[...Model]
  isEmpty:     (Any)->Bool
  invoke:     (Str,Arr)->Any
  last:       (Num?)->Model or [...Model]
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
  sortBy:     ((Str or ((Model,Num)->Num)),Any?)->[...Model]
  sortedIndex:(Model,((Model,Num)->Num)?)->Num
  range:      (Num,Num?,Num?)->Any
  #wat nu? kan alleen als laatste twee optional zijn :)
  #range(stop: number, step?: number): any;
  #range(start: number, stop: number, step?: number): any;
  reduceRight:(((Any,Model,Num)->Any),Any,Any?)->Arr
  reject:     (((Model,Num)->Bool),Any?)->[...Model]
  #deze gaan wel werken maar ze zijn te "weak"
  #we maken de één optioneel en de andere dan met or
  rest:       (Num?)->Model or [...Model]
  tail:       (Num?)->Model or [...Model]
  toArray:    ()->Arr
  union:      ([...Model])->[...Model]
  uniq:       (Bool?,((Model,Num)->Bool)?)->[...Model]
  without:    (Arr)->[...Model]
  zip:        ([...Model])->[...Model]
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
proxy.Router.prototype= copyAndProxyPrototype(backbone.Router.prototype, Router_prototype, backbone.Router)
#todo adapt contracts
#proxy.Collection.prototype= copyAndProxyPrototype(backbone.Collection.prototype,Collection_prototype, backbone.Collection)
proxy.History.prototype=  copyAndProxyPrototype(backbone.History.prototype,History_prototype,backbone.History)


C.setExported proxy.View, "Backbone.View"
C.setExported proxy.Model, "Backbone.Model"

root['proxiedBackbone'] = proxy
