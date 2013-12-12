define ['contracts-js','backbone','collections/todos'], (C,Backbone,Todos)->
  class Session extends Backbone.Model

    defaults:
      name: ''

    idAttribute: '_id'

  Session