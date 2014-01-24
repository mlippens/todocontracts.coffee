
C = require 'contracts-js'



Proxy :: ==> {
  doSomething: (Str)->Any
}
Proxy =
  class Bar
    doSomething: -> console.log "doing something!"


exports = {}
exports.Bar = Proxy


C.setExported exports, "Bar"


#Foo.coffee
{Bar} = C.use exports, "Foo"
class Foo extends Bar

f = new Foo()
f.doSomething 2




