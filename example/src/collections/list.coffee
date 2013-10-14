define ['backbone','models/item'],(Backbone,Item)->
  class List extends Backbone.Collection
    model: Item

  List