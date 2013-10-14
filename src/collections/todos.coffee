define ['backbone','models/todo','backboneLocalStorage','contracts-js'],(Backbone,TodoModel,Store,C)->
  class Todos extends Backbone.Collection
    model: TodoModel
    localStorage: new Store('todos-storage')

    completed: C.guard(C.fun(C.Any, C.Arr),()->
        @filter (todo)->
          todo.get 'completed')

    remaining: C.guard(C.fun(C.Any,C.Arr),()->
        @without.apply(@,@completed()))

    nextOrder: C.guard(C.fun(C.Any,C.Num),()->
        if !@length
          1
        else
          @last().get('order') + 1)

    comparator: C.guard(C.fun(C.Any, C.Num),(todo)->
        todo.get 'order')

  new Todos()
