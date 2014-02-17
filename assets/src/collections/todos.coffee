define ['proxiedBackbone','models/todo','contracts-js'],(Backbone,TodoModel,C)->
  class Todos extends Backbone.Collection
    model: TodoModel

    url: '/rest/todos'

    completed: ()->
        @filter (todo)->
          todo.get 'completed'

    remaining: ()->
        @without(@completed())

    nextOrder: ()->
        if !@length
          1
        else
          @last().get('order') + 1

    comparator: (todo)->
        todo.get 'order'

    #disallow creating a new model with a duplicate title, becomes null operation if so
    create: (todo,options)->
      Backbone.Collection.prototype.create.call(@,todo,options) if not @.any (t)-> t.get('title') is todo.title

