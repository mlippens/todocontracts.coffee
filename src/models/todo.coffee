define ['backbone'],(Backbone)->
  class Todo extends Backbone.Model
    defaults:
      title: ''
      completed: false

    #not usefull to guard, it should be in backbone.js
    toggle: ()->
      @save completed: !@get('completed')

  Todo