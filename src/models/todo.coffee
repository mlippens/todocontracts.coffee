define ['proxiedBackbone','contracts-js'],(Backbone,C)->

  C.import Backbone.Model,"Todo Model"

  class Todo extends Backbone.Model
    defaults:
      title: ''
      completed: false

    #not useful to guard, it should be in backbone.js
    toggle: ()->
      @save completed: !@get('completed')

  Todo