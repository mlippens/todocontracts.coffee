define ['contracts-js','backbone','collections/todos'], (C,Backbone,Todos)->
  class Session extends Backbone.Model
    defaults:
      title: ''
      todos: new Todos()

    idAttribute: '_id'

  Session