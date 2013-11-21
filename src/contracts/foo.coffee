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



events = {}
events['on']          = ?(Any, (Any) -> Any) -> Any
events['off']         = ?(Str,(Any) -> Any) -> Any
events['trigger']     = ?(Str,Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['unbind']      = ?(Str,(Any) -> Any) -> Any
events['listenTo']    = ?(Obj,Str,(Any) -> Any) -> Any

#zorgt ervoor dat _configure (dat in de constructor zit)
#niet gevonden wordt voor 1 of andere reden. (most likely omdat proxy dan
#een contract is etc
proxy ::
  VERSION: Str
  View:       !Constructor
  Model:      !Constructor
  Router:     !Constructor
  Collection: !Constructor
  Events:     !Constructor
  History:    !Constructor
proxy =
  VERSION: backbone.VERSION
  View: backbone.View.bind({})
  Model: backbone.Model.bind({})
  Router: backbone.Router.bind({})
  Collection: backbone.Router.bind({})
  Events: backbone.Events.bind({})
  History: backbone.History.bind({})

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


proxy.View.extend :: (Any)-> Any
proxy.View.extend =  backbone.View.extend

proxy.Model.extend :: (Any)-> Any
proxy.Model.extend= backbone.Model.extend


do (view = backbone.View.prototype)->
  proxy.View.prototype :: View_prototype
  proxy.View.prototype =
        _configure: view._configure
        _ensureElement: view._ensureElement
        constructor: backbone.View
        initialize: view.initialize
        $: view.$
        bind: view.bind
        delegateEvents: view.delegateEvents
        listenTo: view.listenTo
        off: view.off
        on: view.on
        once: view.once
        remove: view.remove
        render: view.render
        setElement: view.setElement
        stopListening: view.stopListening
        tagName: view.tagName
        trigger: view.trigger
        unbind: view.unbind
        undelegateEvents: view.undelegateEvents


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

do (model = backbone.Model.prototype)->
  proxy.Model.prototype :: Model_prototype
  proxy.Model.prototype=
        _validate: model._validate
        bind: model.bind
        changed: model.changed
        changedAttributes: model.changedAttributes
        clear: model.clear
        clone: model.clone
        constructor: backbone.Model
        destroy: model.destroy
        escape: model.escape
        fetch: model.fetch
        get: model.get
        has: model.has
        hasChanged: model.hasChanged
        idAttribute: model.idAttribute
        initialize: model.initialize
        isNew: model.isNew
        isValid: model.isValid
        listenTo: model.listenTo
        off: model.off
        on: model.on
        once: model.once
        parse: model.parse
        previous: model.previous
        previousAttributes: model.previousAttributes
        save: model.save
        set: model.set
        stopListening: model.stopListening
        sync: model.sync
        toJSON: model.toJSON
        trigger: model.trigger
        unbind: model.unbind
        unset: model.unset
        url: model.url

#mimic and copy the constructor in the prototype, since it is not copied from the function.
#proxy.View.prototype.constructor  = backbone.View
#proxy.Model.prototype.constructor = backbone.Model

#todo: fix this, doesn't work for some weird reason(?)
###for name of proxy
  C.setExported proxy[name], "Backbone.#{name}"###

C.setExported proxy.View, "Backbone.View"
C.setExported proxy.Model, "Backbone.Model"

root['proxiedBackbone'] = proxy
