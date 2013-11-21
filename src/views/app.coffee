define ['jquery',
  'underscore',
  'proxiedBackbone',
  'collections/todos',
  'views/tododetail',
  'text!templates/stats.html',
  'text!templates/todo-overview.html',
  'common'
  'contracts-js'],
  ($, _,Backbone, Todos, TodoView, statsTemplate,overviewTemplate, Common, C)->
    class AppView extends Backbone.View

      #context of this view
      el: '#todoapp',

      template: _.template(statsTemplate),

      events:
        'keypress #new-todo': 'createOnEnter',
        'click #clear-completed': 'clearCompleted',
        'click #toggle-all': 'toggleAllComplete'

      initialize: ()->
        @$el.html(_.template(overviewTemplate,{}))
        @allCheckbox = @.$('#toggle-all')[0]
        #mimic backbone style
        @$input = @.$('#new-todo')
        @$footer = @.$('#footer')
        @$main = @.$('#main')
        #on added
        @listenTo Todos, 'add', @addOne
        #on fetch (see stacktrace)
        @listenTo Todos, 'reset', @addAll
        #on a change of the completed field
        @listenTo Todos, 'change:completed', @filterOne
        #on a filter event (filter is triggered in the router)
        @listenTo Todos, 'filter', @filterAll
        #render is triggered on all events
        @listenTo Todos, 'all', @render

        @listenTo false
        #triggers reset
        Todos.fetch()

      render: ()->
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
        @

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


