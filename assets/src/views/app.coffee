define ['jquery',
  'underscore',
  'proxiedBackbone',
  'collections/todos',
  'models/todo',
  'views/tododetail',
  'text!templates/stats.html',
  'text!templates/todo-overview.html',
  'common'
  'contracts-js'
  'socketio'],
  ($, _,Backbone, Todos, TodoModel, TodoView, statsTemplate,overviewTemplate, Common, C,Socket)->

    #import into the contract system.
    #Backbone = C.use(Backbone,"App View")

    class AppView extends Backbone.View

      #context of this view
      el: '#todoapp',

      template: _.template(statsTemplate),

      events:
        'keypress #new-todo': 'createOnEnter',
        'click #clear-completed': 'clearCompleted',
        'click #toggle-all': 'toggleAllComplete'

      initialize: ()->
        Todos = new Todos()
        Todos.url = "rest/todos/session/#{@model.id}" if @model
        Common.todos = Todos

        @connection = Socket.connect "http://localhost:4711"

        that = @
        #we register all the events that require us to change our application view/state
        @connection.on "add",(data)->
          console.log Todos
          todo = new TodoModel(data)
          Todos.add todo if (not Todos.any (t)->t.get('_id') == data.id) and that.model?.id is data.session

        @connection.on "update",(data)->
          todo = Todos.filter (t)-> t.get('_id') == data._id
          todo[0].set(data) if todo.length isnt 0

        @connection.on "remove",(data)->
          todo = Todos.filter (t)-> t.get('_id') == data._id
          Todos.remove(todo[0]) if todo.length isnt 0
          Todos.trigger 'reset'




        @$el.html(_.template(overviewTemplate,{title: @model?.get('name') || "Todos"}))
        @allCheckbox = @.$('#toggle-all')[0]
        #mimic backbone style
        @$input = @.$('#new-todo')
        @$footer = @.$('#footer')
        @$main = @.$('#main')
        #on added
        @listenTo Todos, 'add', @addOne
        #now we use socket to add

        #on fetch (see stacktrace)
        @listenTo Todos, 'reset', @addAll
        #on a change of the completed field
        @listenTo Todos, 'change:completed', @filterOne
        #on a filter event (filter is triggered in the router)
        @listenTo Todos, 'filter', @filterAll
        #render is triggered on all events
        @listenTo Todos, 'all', @render

        #d@listenTo false
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

      newAttributes: ()->
        title: @$input.val().trim()
        order: Todos.nextOrder()
        completed: false
        session: @model.id if @model

      createOnEnter: (e)->
        if !(e.which != Common.ENTER_KEY || !@$input.val().trim())
          Todos.create @newAttributes()
          @$input.val ''

      clearCompleted: ()->
        _.invoke Todos.completed(), 'destroy'
        false

      toggleAllComplete: ()->
        completed = @allCheckbox.checked
        Todos.each (todo)->
          todo.save 'completed': completed


