define ['backbone','models/todo','backboneLocalStorage'],(Backbone,TodoModel,Store)->
  class Todos extends Backbone.Collection
    model: TodoModel
    localStorage: new Store('todos-storage')

    completed: ()->
      @filter (todo)->
        todo.get 'completed'

    remaining: ()->
      @without.apply(@,@completed)

    nextOrder: ()->
      if !@length
        1
      else
        @last().get('order') + 1

    comparator: (todo)->
      todo.get 'order'

  Todos
