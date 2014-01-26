root = exports ? this

backbone = if root['Backbone'] then root['Backbone'] else require 'backbone'

###Model       = ?!(x)-> x instanceof Backbone.Model or _.isUndefined(x)
View        = ?!(x)-> x instanceof Backbone.View or _.isUndefined(x)
Router      = ?!(x)-> x instanceof Backbone.Router or _.isUndefined(x)
Collection  = ?!(x)-> x instanceof Backbone.Collection or _.isUndefined(x)
Events      = ?!(x)-> x instanceof Backbone.Events or _.isUndefined(x)
History     = ?!(x)-> x instanceof Backbone.History or _.isUndefined(x)###



Obj         = ?!(x)-> if _.isUndefined(x) or _.isObject(x)
  true
else
  false

Model       = ?Obj
View        = ?Obj
Router      = ?Obj
Collection  = ?Obj
Events      = ?Obj
History     = ?Obj



Silencable = ? {
  silent: Bool?
}
AddOptions = ? {
  parse:  Bool?
  previousModels: [...Model]?
  success: (Any?)->Any
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
  #toJSON:       (Any?)->Any fails despite being most general function contract(?)
  #0.9 sync:         (Str,Obj,Obj?)-> Any

  #original
  sync:         (Str)->Any

  #underscore mixins
  keys:         ()->[...Str]
  values:       ()->[...Any]
  pairs:        ()->[...Any]
  invert:       ()->Any
  pick:         ([...Str])->Any
  omit:         ([...Str])->Any
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
  get: (Any)-> Model
  #fetch
  on:   !events['on']
  off:  !events['off']
  once: !events['once']
  #parse
  pluck: (Str)-> Any
  push: (Model,AddOptions?)->Model
  pop: (Silencable?)-> Model
  remove: (Model or [...Model], Silencable?)-> Model or [...Model]

  #CAUSES ERROR: when an Array is passed to reset is suddenly is an object and not an array anymore?! wtf
  #reset:  ([...Model]?,Silencable?)->[...Model]
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
  difference: ([...Model])->[...Model]
  drop:       (Num?)-> Model or [...Model]
  each:       (((Model,Num,Any?)->Any),Any?)-> Any
  every:      (((Model,Num)->Bool),Any?)->Bool
  filter:     (((Model,Num)->Bool),Any?)->[...Model]
  find:       (((Model,Num)->Bool),Any?)->Model
  first:      (Num?)->Model or [...Model]
  #1.0 flatten:    (Bool?)-> [...Model]
  foldl:      (((Any,Model,Num)->Any),Any,Any?)->Any
  foldr:      (((Any,Model,Num)->Any),Any,Any?)->Any
  forEach:    (((Model,Num,Any?)->Any),Any?)->Any
  #todo: implement
  #groupBy:
  #head
  include:    (Any)->Bool
  indexOf:    (Model,Bool?)->Num
  initial:    (Num?)->Model or [...Model]
  inject:     (((Any,Model,Num)->Any),Any,Any?)->Any
  #1.0 intersection: ([...Model])->[...Model]
  isEmpty:     (Any)->Bool
  invoke:     (Str,Arr)->Any
  last:       (Num?)->Model or [...Model]
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
  #@todo sortBy:     ((Str or ((Model,Num)->Num)),Any?)->[...Model]


  #sortedIndex:(Model,((Model,Num)->Num)?)->Num
  #@dep range:      (Num,Num?,Num?)->Any
  #wat nu? kan alleen als laatste twee optional zijn :)
  #range(stop: number, step?: number): any;
  #range(start: number, stop: number, step?: number): any;

  reduceRight:(((Any,Model,Num)->Any),Any,Any?)->Arr
  reject:     (((Model,Num)->Bool),Any?)->[...Model]
  #deze gaan wel werken maar ze zijn te "weak"
  #we maken de één optioneel en de andere dan met or
  rest:       (Num?)->Model or [...Model]
  #select
  #shuffle
  #size
  #some
  #sortBy
  tail:       (Num?)->Model or [...Model]
  #take
  toArray:    ()->Arr
  #toJSON
  #1.0 union:      ([...Model])->[...Model]
  #1.0 uniq:       (Bool?,((Model,Num)->Bool)?)->[...Model]
  without:    ([...Model]?)->[...Model]
  #zip:        ([...Model])->[...Model]
}

proxy ::
  Model:      {
    prototype: {}
  }
proxy = backbone

###  $:          (Any)-> Any
  View:       {
    prototype: !View_prototype
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
  emulateHTTP:Bool
  emulateJSON:Bool
  history:    Any
  listenTo:   !events['listenTo']
  noConflict: Any
  off:        !events['off']
  on:         !events['on']
  once:       !events['once']
  stopListening: !events['stopListening']
  sync:       Any
  trigger:    !events['trigger']
  unbind:     !events['off']###

#for some reason needed? This does affect backbone! and this is a problem...
#we need to understand why this is needed for instanceof
###for prop of proxy
  if proxy[prop]['prototype']
    proxy[prop]['prototype'] = Object.create(proxy[prop]['prototype'])###


root['proxiedBackbone'] = proxy