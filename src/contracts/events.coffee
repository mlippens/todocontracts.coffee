#needs to be compiled with contracts.coffee to generate contract code!
#load contracts
root = exports ? this

C = root['contracts-js']
Backbone = root['Backbone']

makeObjChecker = (prop,obj,label)->
  C.check(((e)->
    e isnt null && typeof e is 'object' && e[prop] is obj),label)

#custom checks
Obj = C.check(((e)->
  e isnt null && typeof e == 'object'),"Object")
Arr = C.check(((e)->
  e isnt null && typeof e.length == 'number'))
Model       = makeObjChecker('__proto__',Backbone.Model.prototype,"Model")
View        = makeObjChecker('__proto__',Backbone.View.prototype,"View")
Collection  = makeObjChecker('__proto__',Backbone.Collection.prototype,"Collection")


events = {}

events['on']          = ?(Any, (Any) -> Any) -> Any
events['off']         = ?(Str,(Any) -> Any) -> Any
events['trigger']     = ?(Str,Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['unbind']      = ?(Str,(Any) -> Any) -> Any
events['bind']        = ?(Str,(Any) -> Any) -> Any
events['listenTo']    = ?(Obj,Str,(Any) -> Any) -> Any

view = {}
#de model check moet op een class staan die het implementeert, en niet op
#het prototype object in backbone!
#view['model']         = ?(Model)


doGuard = (obj,container)->
  for c of obj
    do (contract = c)->
      guarded = C.guard(obj[contract],container[contract])
      container[contract] = guarded

doGuard(events,Backbone.View.prototype)

#set this module as exported with the corresponding modulename
C.setExported(Backbone.View.prototype,"Backbone.View")

#mogelijk... maar dit lost niets op! want de contracten staan op de prototype.
#dus we hebben effectief 'iets' nodig dat voor ons precies zegt, van kijk, dit is een gecontracteerd
#object, en de contracten moet je daar en daar en daar gaan vinden
#op die manier kunnen we eigenlijk zowel het plaatsen van de objecten als het importeren van objecten
#meer streamlinen. (lost nog altijd niets op van als backbone zelf dingen callt die we moeten implementeren)
define("Backbone.View",[],()->
  return Backbone.View)

###for c of events
  do (contract = c)->
    guarded = C.guard(events[contract],Backbone.View.prototype[contract],"Backbone")
    Backbone.View.prototype[contract] = guarded###

#events kan exports worden;
#het effectieve guarden in require vervangen -CF

#didactische implementatie



#idee: voor use (dus wanneer we backbone importeren)
#we kunnen kijken of de eerste letter uppercase is.
#in dat geval kunnen we kijken naar de prototype voor contracten, en daar de labels dus juist zetten m.b.v.
#de bestaande use. Op die manier kunnen we Backbone volledig & eenvoudig wrappen.
#het effectieve wrappen van de contracten kan hier gebeuren. Misschien kijken voor een betere manier
#om dit te definieren...(?)

#rekening houden:
#niet alle modules werken zo.. dus het is waarschijnlijk geen general purpose methode.
#bovendien steunt hij op een conventie binnen de javascript wereld.. De vraag is hoe 'brittle' dit is?

#alternatief is: elk deel van Backbone dat we gebruiken apart importeren in plaats van volledig backbone.
#dan bvb define('foo',['BackboneModel'],(Model)->
#
#dan moeten we wel alle delen apart definieren en registreren, voor de rest weinig verschil.

#maken we zelf een class dat bvb een backbone model is, dan moeten we zelf contracten plaatsen indien we die willen.
#de methoden van hun prototypes worden correct gezet normaal indien we Backbone zelf, of de corresponderende class vanwat
#het 'inherit' ook importeren (afhankelijk van de strategie die gekozen werd)


### TO DISCUSS WITH TVC ###
#Probleem hiermee: wat als backbone ZELF code callt waar wij net contracten opgezet hebben, dan worden die gewoon
#nooit toegepast! Wat we 'kunnen' doen is gewoon toch de contracten plaatsen, de setExported of exported functie
#van contracts.js gebruiken, en dan als backbone het oproept dan krijgen we (normaal) toch een violation indien het
#niet klopt. We kunnen alleen geen blame geven aan backbone zelf dan in dat geval!
