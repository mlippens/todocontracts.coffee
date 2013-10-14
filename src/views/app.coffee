define ['jquery',
        'underscore',
        'backbone',
        'collections/todos',
        'views/todos',
        'text!templates/stats.html',
        'common'
        'contracts-js'], ($, _, Backbone, Todos, TodoView, statsTemplate, Common, C)->
  class AppView extends Backbone.View
    el: '#todoapp',

    template: _.template(statsTemplate),

    events:
      'keypress #new-todo': 'createOnEnter',
      'click #clear-completed': 'clearCompleted',
      'click #toggle-all': 'toggleAllComplete'

    initialize: ()->
      @allCheckbox = @.$('#toggle-all')[0]
      @$input = @.$('#new-todo')
      @$footer = @.$('#footer')
      @$main = @.$('#main')

      @listenTo Todos, 'add', @addOne
      @listenTo Todos, 'reset', @addAll
      @listenTo Todos, 'change:completed', @filterOne
      @listenTo Todos, 'filter', @filterAll
      @listenTo Todos, 'all', @render

      #triggers reset(?)
      Todos.fetch()

    render: C.guard(C.fun(C.Any,C.Self), ()->
        completed = Todos.completed().length
        remaining = Todos.remaining().length

        if Todos.length
          @$main.show()
          @$footer.show()

          @$footer.html(@template completed: completed, remaining: remaining)
          @.$('#filters li a')
          .removeClass('selected')
          .filter('[href="#/' + (Common.TodoFilter || '') + '"]')
          .addClass('selected')
        else
          @$main.hide()
          @$footer.hide()
        @allCheckbox.checked = !remaining
        @)

    addOne: (todo)->
      view = new TodoView model: todo
      $('#todo-list').append(view.render().el)

    addAll: ()->
      @.$('#todo-list').html('')
      Todos.each(@addOne, @)

    filterOne: (todo)->
      todo.trigger 'visible'

    filterAll: ()->
      Todos.each(@filterOne, @)

    newAttributes: C.guard(C.fun(C.Any,C.object({title: C.Str,order: C.Num, completed: C.Bool})),()->
      title: @$input.val().trim()
      order: Todos.nextOrder()
      completed: false)

    #Simplified test for an Event contract
    isEvent: C.check(((e)->
      e.which isnt 'undefined'),'Event')

    createOnEnter: C.guard(C.fun(@.prototype.isEvent,C.Any),(e)->
      if !(e.which != Common.ENTER_KEY || !@$input.val().trim())
        Todos.create @newAttributes()
        @$input.val '')

    clearCompleted: ()->
      _.invoke Todos.completed(), 'destroy'
      false

    toggleAllComplete: ()->
      completed = @allCheckbox.checked
      Todos.each (todo)->
        todo.save 'completed': completed

