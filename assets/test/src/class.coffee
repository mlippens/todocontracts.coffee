root = this ? exports

class A
  constructor: ->
    @bar = "hello"
    @foo(2)

  foo: -> console.log "foo"


contractedA :: {
    prototype: {
      foo: (Num)->Any
    }
}

#contractedA = class B extends A (this doesn't work)
contractedA = ->
contractedA.prototype = Object.create(A.prototype)#this does

contractedA.prototype.foo = -> console.log "contracted foo"
#contractedA.prototype.bar = -> console.log "bar"

#this gets the regular behaviour
console.log "contractedA"
l = new contractedA()
console.log l.bar


#this is the behaviour we'd expect, but we don't get it on the subclassed class
console.log "Regular subclassing"
B = ->
B.prototype = Object.create(A.prototype)
v = new B()
console.log v.bar

console.log "Foo extends contractedA"

class Foo extends contractedA
f = new Foo()
console.log f.bar

console.log "Bar extends A"

class Bar extends A
g = new Bar()
console.log g.bar

#apparently the behaviour is the same, BUT oldskool subclassing has a different effect than using coffeescript's extend!
#why does bind work, but -> class.apply(@,arguments) doesn't? It's supposed to do the same thing as bind does (more or less?)

