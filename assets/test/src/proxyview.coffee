root = this ? exports

backbone  = root['Backbone']
_         = root['_']

View = backbone.View

proxyView = ->
proxyView.prototype = Object.create(View.prototype)

Obj         = ?!(x)-> _.isObject(x)

View_contract = ?{
  listenTo: (Obj,Str,(Any?) -> Any) -> Any
}

#so it seems the basic example of nesting here works as we'd expect too... so where is the error?
proxy ::
  View: {
    prototype: !View_contract
  }

proxy =
  View: proxyView


class Foo extends proxy.View

root['proxy'] = proxy
root['foo'] = Foo