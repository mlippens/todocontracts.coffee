define ['contracts-js','backbone','collections/todos'], (C,Backbone,Todos)->
  class Category extends Backbone.Model
    defaults:
      name: ''

  Category