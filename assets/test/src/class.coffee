root = this ? exports

class A
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
contractedA.prototype.bar = -> console.log "bar"

a = new A()
a.foo()#expects "foo"

b = new contractedA()
console.log b instanceof A #true
b.bar()
b.foo(2)#no contract violation and prints "contracted foo"
#b.foo("string")#contract violation

class Foo extends contractedA

console.log new Foo() instanceof A
new Foo().foo("bar")



