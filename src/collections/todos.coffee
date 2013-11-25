define ['proxiedBackbone','models/todo','backboneLocalStorage','contracts-js'],(Backbone,TodoModel,Store,C)->
  class Todos extends Backbone.Collection
    model: TodoModel
    localStorage: new Store('todos-storage')

    completed: ()->
        @filter (todo)->
          todo.get 'completed'

    remaining: ()->
        @without.apply(@,@completed())

    nextOrder: ()->
        if !@length
          1
        else
          @last().get('order') + 1

    comparator: (todo)->
        todo.get 'order'

  new Todos()
