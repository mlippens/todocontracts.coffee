root = exports ? this

backbone =  root['Backbone']
C        =  root['contracts-js']

makeArrContract = (type)->
  (a)-> a.length isnt 'undefined' and typeof a.length is 'number' and (allInstanceOf(a,type) or a.length is 0)

makeArrTypeContract = (t)->
  (a)-> a.length isnt 'undefined' and typeof a.length is 'number' and (allTypeOf(a,t) or a.length is 0)


allTypeOf = (a,type)->
  for i in [0..a.length-1]
    if not (typeof a[i] is type)
      return false
  return true

allInstanceOf = (a,type)->
  for i in [0..a.length-1]
    if not (a[i] instanceof type)
      return false
  return true

Arr = ? {
length: !(x)-> typeof x is "number"
}

Arr_like = ?!(x)->
  typeof x.length isnt 'undefined'

Obj         = ?!(x)-> _.isObject x

Model       = ?!(x)-> x instanceof backbone.Model
ModelArr    = ?!makeArrContract(backbone.Model)

View        = ?!(x)-> x instanceof backbone.View
ViewArr     = ?!makeArrContract(backbone.View)

Router      = ?!(x)-> x instanceof backbone.Router
RouterArr   = ?!makeArrContract(backbone.Router)

Collection  = ?!(x)-> x instanceof backbone.Collection
CollectionArr = ?!makeArrContract(backbone.Collection)

Events      = ?!(x)-> x instanceof backbone.Events
EventsArr   = ?!makeArrContract(backbone.Events)

History     = ?!(x)-> x instanceof backbone.History
HistoryArr  = ?!makeArrContract(backbone.History)

StrArr      = ?!makeArrTypeContract("string")


Silencable = ? {
  silent: Bool?
}

AddOptions = ? {
  parse:  Bool?
  previousModels: ModelArr?
  success: (Any?)->Any
}

NavigateOptions = ? {
  trigger: Bool
}
HistoryOptions = ? {
  pushState: Bool?
  root:      Str?
}
Validable = ? {
  validate: Bool?
}
Waitable = ? {
  wait: Bool?
}
Parseable = ? {
  parse: Any?
}
PersistenceOptions = ? {
  url: Str?
  beforeSend: ((Any)->Any)?
  success: ((Any?,Any?,Any?)-> Any)?
  error: ((Any?,Any?,Any?)-> Any)?
}

ModelSetOptions = ? {
  silent: Bool?
  validate: Bool?
}
ModelFetchOptions = ? {
  silent: Bool?
  parse: Bool?
  url: Str?
  beforeSend: ((Any)->Any)?
  success: ((Any?,Any?,Any?)-> Any)?
  error: ((Any?,Any?,Any?)-> Any)?
}
ModelSaveOptions = ? {
  silent: Bool?
  wait: Bool?
  validate: Bool?
  parse: Any?

  url: Str?
  beforeSend: ((Any)->Any)?
  success: ((Any?,Any?,Any?)-> Any)?
  error: ((Any?,Any?,Any?)-> Any)?
}

ModelDestroyOptions = ? {
  wait: Bool?

  url: Str?
  beforeSend: ((Any)->Any)?
  success: ((Any?,Any?,Any?)-> Any)?
  error: ((Any?,Any?,Any?)-> Any)?
}

CollectionFetchOptions = ? {
  parse: Bool?

  url: Str?
  beforeSend: ((Any)->Any)?
  success: ((Any?,Any?,Any?)-> Any)?
  error: ((Any?,Any?,Any?)-> Any)?
}

OptionalDefaults = ? {
  defaults: (()->Any)?
}


Constructor = ?(Any) ==> Any
Extend      = ?(Any)-> Any

events = {}
events['on']          = ?(Str, ((Any?) -> Any?)?,Any?) -> Any
events['off']         = ?(Str?,((Any?) -> Any?)?,Any?) -> Any

#original:
#events['trigger']     = ?(Str,Arr) -> Any
events['trigger']      = ?(Str,Obj?,Any?)->Any
#identical to on and off just aliases
###events['bind']        = ?(Str,(Any) -> Any) -> Any
events['unbind']      = ?(Str,(Any) -> Any) -> Any###
events['listenTo']    = ?(Obj,Str,(Any?) -> Any) -> Any
#deprecated so it seems
#events['listenToOnce']= ?(Obj,Str,(Any?) -> Any)-> Any
events['stopListening']=?(Obj?,Str?,((Any?)->Any)?)->Any
events['once']        =?(Str,((Any?)->Any),Any?)->Any

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
  #_configure:         (Obj)->Any

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
  urlRoot:      Any?

  changedAttributes: (Any?)-> Arr
  clear:        (Silencable?) -> Any
  clone:        () -> Any
  destroy:      (Obj?) -> Any
  escape:       (Str) -> Str

  get:          (Str) -> Any
  set:          (Any) -> Any #mult options?

  has:          (Str) -> Bool
  hasChanged:   (Str?)-> Bool
  isNew:        ()-> Bool
  isValid:      ()-> Bool
  previous:     (Str)-> Any
  #previous: (Str)-> Bool This failed but no contract violation. Hmm?
  previousAttributes: ()-> Arr

  save:         (Any?,Any?)->Any
  unset:        (Str,Silencable?)-> Obj

  parse:        (Any,Any?)->Any
  toJSON:       (Any?)->Any #fails despite being most general function contract(?)
  #0.9 sync:         (Str,Obj,Obj?)-> Any

  #original
  sync:         (Str)->Any

  #underscore mixins
  keys:         ()->StrArr
  values:       ()->Arr
  pairs:        ()->Arr
  invert:       ()->Any
  pick:         (StrArr)->Any
  omit:         (StrArr)->Any
}

Collection_prototype = ? {
  model: (Any?)->Any

  #models: Any
  #collection: Model
  #length: Num

  #comparator: (Model,Model?)->Any

  #add: (Model or [...Model],Silencable?, AddOptions?) -> Any
  add: (Arr or Obj,Silencable?,AddOptions?)->Any

  at: (Num)-> Model
  bind: !events['on']
  create: (Any, Any)-> Model
  #clone
  get: (Any)-> Model?
  #fetch
  on:   !events['on']
  off:  !events['off']
  once: !events['once']
  #parse
  pluck: (Str)-> Any
  push: (Model,AddOptions?)->Model
  pop: (Silencable?)-> Model
  remove: (Model or ModelArr, Silencable?)-> Model or ModelArr

  reset:  (ModelArr?,Silencable?)->ModelArr
  shift:  (Silencable?)-> Model
  #slice
  sort:   (Silencable?)-> Collection
  #sortedIndex:
  stopListening: !events['stopListening']
  #sync
  trigger: !events['trigger']
  unbind: !events['off']
  #update
  unshift: (Model,Any)-> Model
  where: (Any)-> Arr


  #mixins from underscore
  #todo: generalise
  all:        (((Model,Num)->Bool),Any?)->Bool
  any:        (((Model,Num)->Bool),Any?)->Bool
  collect:    (((Model,Num,Any?)->Arr),Any?)->Arr
  chain:      ()-> Any
  #1.0 compact:    ()-> [...Model]
  contains:   (Any)->Bool
  countBy:    (Str or (Model,Num)->Any)-> Arr
  detect:     (((Any)->Bool),Any?)-> Any
  difference: (ModelArr)->ModelArr
  drop:       (Num?)-> Model or ModelArr
  each:       (((Model,Num,Any?)->Any),Any?)-> Any
  every:      (((Model,Num)->Bool),Any?)->Bool
  filter:     (((Model,Num)->Bool),Any?)->ModelArr
  find:       (((Model,Num)->Bool),Any?)->Model
  first:      (Num?)->Model or ModelArr
  #1.0 flatten:    (Bool?)-> ModelArr
  foldl:      (((Any,Model,Num)->Any),Any,Any?)->Any
  foldr:      (((Any,Model,Num)->Any),Any,Any?)->Any
  forEach:    (((Model,Num,Any?)->Any),Any?)->Any
  #todo: implement
  #groupBy:
  #head
  include:    (Any)->Bool
  indexOf:    (Model,Bool?)->Num
  initial:    (Num?)->Model or ModelArr
  inject:     (((Any,Model,Num)->Any),Any,Any?)->Any
  #1.0 intersection: (ModelArr)->ModelArr
  isEmpty:     (Any)->Bool
  invoke:     (Str,Arr)->Any
  last:       (Num?)->Model or ModelArr
  lastIndexOf:(Model,Num?)->Num
  map:        (((Model,Num,Any?)->Arr),Any?)->Arr
  max:        (((Model,Num,Any?)->Any)?,Any?)->Model
  min:        (((Model,Num,Any?)->Any)?,Any?)->Model

  #1.0 object:     (Arr)->Arr
  reduce:     (((Any,Model,Num)->Any),Any,Any?)->Any
  select:     (Any,Any?)->Arr
  size:       ()->Num
  shuffle:    ()->Arr
  some:       (((Model,Num)->Any),Any?)->Bool
  #@todo sortBy:     ((Str or ((Model,Num)->Num)),Any?)->ModelArr


  #@dep sortedIndex:(Model,((Model,Num)->Num)?)->Num
  #@dep range:      (Num,Num?,Num?)->Any
  #wat nu? kan alleen als laatste twee optional zijn :)
  #range(stop: number, step?: number): any;
  #range(start: number, stop: number, step?: number): any;

  reduceRight:(((Any,Model,Num)->Any),Any,Any?)->Arr
  reject:     (((Model,Num)->Bool),Any?)->ModelArr
  #deze gaan wel werken maar ze zijn te "weak"
  #we maken de één optioneel en de andere dan met or
  rest:       (Num?)->Model or ModelArr
  #select
  #shuffle
  #size
  #some
  #sortBy
  tail:       (Num?)->Model or ModelArr
  #take
  toArray:    ()->Arr
  #toJSON
  #1.0 union:      (ModelArr)->ModelArr
  #1.0 uniq:       (Bool?,((Model,Num)->Bool)?)->ModelArr
  without: (ModelArr?)->ModelArr
  #zip:        (ModelArr)->ModelArr
}

###copyProps = (obj,result)->
  if result is null
    result = {}
  for own prop of obj
    result[prop] = obj[prop]
  result

proxyPrototype = (orig,contract,constructor)->
  result = Object.create(orig)
  #result.constructor = constructor
  result :: contract
  result = result
  return result###

proxyView = ->
proxyView.prototype = Object.create(backbone.View.prototype)

proxyModel = ->
proxyModel.prototype = Object.create(backbone.Model.prototype)

proxyCollection = ->
proxyCollection.prototype = Object.create(backbone.Collection.prototype)

proxyHistory = ->
proxyHistory.prototype = Object.create(backbone.History.prototype)

proxyRouter = -> Router.apply(@,arguments)
proxyRouter.prototype = Object.create(backbone.Router.prototype)

proxy ::
  $:          (Any)-> Any
  View:       {
    prototype: !View_prototype
  }
  Model:      {
    prototype: !Model_prototype
  }
  Router:     {
    prototype: !Router_prototype
  }
  Collection: {
    prototype: !Collection_prototype
  }
  Events:     Obj
  History:    {
    prototype: !History_prototype
  }
  VERSION:    Str
  bind:       !events['on']
  emulateHTTP: Bool
  emulateJSON: Bool
  history:    !History
  listenTo:   !events['listenTo']
  localSync:  Any
  noConflict: Any
  off:        !events['off']
  on:         !events['on']
  once:       !events['once']
  stopListening: !events['stopListening']
  sync:       Any
  trigger:    !events['trigger']
  unbind:     !events['off']
proxy =
  $:          backbone.$
  View:       proxyView
  Model:      proxyModel
  Router:     proxyRouter
  Collection: proxyCollection
  Events:     backbone.Events
  History:    proxyHistory
  VERSION:    backbone.VERSION
  bind:       backbone.bind
  emulateHTTP: backbone.emulateHTTP
  emulateJSON: backbone.emulateJSON
  history:    backbone.history
  listenTo:   backbone.listenTo
  localSync:  backbone.localSync
  noConflict: backbone.noConflict
  off:        backbone.off
  on:         backbone.on
  once:       backbone.once
  stopListening: backbone.stopListening
  sync:       backbone.sync
  trigger:    backbone.trigger
  unbind:     backbone.unbind

exports = {}
exports.proxy = proxy
C.setExported exports, "Backbone"
root['proxiedBackbone'] = proxy
