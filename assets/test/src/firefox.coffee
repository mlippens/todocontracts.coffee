root = this ? exports

###
_ = if typeof require is "function"
      require "underscore"
    else
      root['_']

Backbone = if typeof require is "function"
            require "backbone"
          else
            root['Backbone']
###

Foo = ()->
  @.yeah()

Foo.prototype.yeah = -> console.log "oh yeah"

Proxy :: {
  prototype: {}
}
Proxy = Foo

class Bar extends Proxy

f = new Bar()
