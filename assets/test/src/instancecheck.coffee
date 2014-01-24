root = this ? exports
Backbone = if typeof require is "function"
    require "backbone"
  else
    root['Backbone']


#class A
class A

contractedA :: {
  prototype: {}
}
contractedA = A

class SubContractedA extends contractedA


subContractedA = new SubContractedA()

console.log "We instantiated an object of contractedA."
console.log "is the instance an instance of Backbone.Model?=> #{subContractedA instanceof A}"


###contractedBackbone :: {
  Model: {
    prototype: {}
  }
}
contractedBackbone = Backbone

class SubcontractedB extends contractedBackbone.Model
subContractedB = new SubcontractedB()


console.log "We instantiated an object of contractedBackbone."
console.log "is the instance an instance of Backbone.Model?=> #{subContractedB instanceof Backbone.Model}"###










