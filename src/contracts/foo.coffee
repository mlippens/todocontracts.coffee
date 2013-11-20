root = exports ? this

backbone =  root['Backbone']
C        =  root['contracts-js']

Obj = ?! (x)-> x isnt null and typeof x is 'object'

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
  View: (Any) ==> Any
  Model: (Any) ==> Any
proxy =
  VERSION: backbone.VERSION
  View: backbone.View.bind({})
  Model: backbone.Model.bind({})

View_prototype = ? {
  on: !events['on']
  off: !events['off']
  trigger: !events['trigger']
  bind: !events['bind']
  unbind: !events['unbind']
  listenTo: !events['listenTo']
  tagName: Str
  initialize: (Any) -> Any
  $: (Str)-> Any
  setElement: (Any, Bool) -> Any
  render: (Any) -> Any
  remove: (Any) -> Any
  delegateEvents: (Any) -> Any
  undelegateEvents: (Any) -> Any
}

Model_prototype = ? {
}

proxy.View.extend :: (Any)-> Any
proxy.View.extend =  backbone.View.extend

do (view = backbone.View.prototype)->
  proxy.View.prototype :: View_prototype
  proxy.View.prototype =
        _configure: view._configure
        _ensureElement: view._ensureElement
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

###proxy.Model.extend :: (Any)-> Any
proxy.Model.extend= backbone.Model.extend

proxy.Model.prototype :: Model_prototype
proxy.Model.prototype=
      bind: backbone.Model.prototype.bind
      changed: backbone.Model.prototype.changed
      changedAttributes: backbone.Model.prototype.changedAttributes
      clear: backbone.Model.prototype.clear
      clone: backbone.Model.prototype.clone
      constructor: backbone.Model.prototype.constructor
      destroy: backbone.Model.prototype.destroy
      escape: backbone.Model.prototype.escape
      fetch: backbone.Model.prototype.fetch
      get: backbone.Model.prototype.get
      has: backbone.Model.prototype.has
      hasChanged: backbone.Model.prototype.hasChanged
      initialize: backbone.Model.prototype.initialize
      isNew: backbone.Model.prototype.isNew
      isValid: backbone.Model.prototype.isValid
      listenTo: backbone.Model.prototype.listenTo
      off: backbone.Model.prototype.off
      on: backbone.Model.prototype.on
      once: backbone.Model.prototype.once
      parse: backbone.Model.prototype.parse
      previous: backbone.Model.prototype.previous
      previousAttributes: backbone.Model.prototype.previousAttributes
      save: backbone.Model.prototype.save
      set: backbone.Model.prototype.set
      stopListening: backbone.Model.prototype.stopListening
      sync: backbone.Model.prototype.sync
      toJSON: backbone.Model.prototype.toJSON
      trigger: backbone.Model.prototype.trigger
      unbind: backbone.Model.prototype.unbind
      unset: backbone.Model.prototype.unset
      url: backbone.Model.prototype.url###

C.setExported proxy.View.prototype, "Backbone View"
C.setExported proxy.Model.prototype, "Backbone Model"

root['proxiedBackbone'] = proxy
