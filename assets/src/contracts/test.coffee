
makeArrContract = (type)->
  (a)-> a.length isnt 'undefined' and typeof a.length is 'number' and allOfType a,type

allOfType = (a,type)->
  for i in [0..a.length-1]
    if not (a[i] instanceof type)
      return false
  return true

Foo = ->


checker = ?!makeArrContract(Foo)

f = new Foo()
b = new Foo()

foo :: {
  arr: checker
}
foo= {
 arr: [f,b,f]
}

foo.arr = ["foo"]

console.log foo
