define ['backbone'],(Backbone)->
  class Todo extends Backbone.Model
    defaults:
      title: ''
      completed: false

    toggle: ()->
      @save completed: !@get('completed')

  Todo