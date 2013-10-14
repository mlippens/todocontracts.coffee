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
      @TodosCollection = new Todos()
      @allCheckbox = @.$('#toggle-all')[0]
      @$input = @.$('#new-todo')
      @$footer = @.$('#footer')
      @$main = @.$('#main')

      @listenTo @TodosCollection, 'add', @addOne
      @listenTo @TodosCollection, 'reset', @addAll
      @listenTo @TodosCollection, 'change:completed', @filterOne
      @listenTo @TodosCollection, 'filter', @filterAll
      @listenTo @TodosCollection, 'all', @render

      @TodosCollection.fetch()

    render: ()->
      completed = @TodosCollection.completed().length
      remaining = @TodosCollection.remaining().length

      if @TodosCollection.length
        @$main.show()
        @$footer.show()

        @$footer.html(@template completed: completed, remaining: remaining)
        @.$('#filters li a')
        .removeClass('selected')
        .filter('[href="#'+(Common.TodoFilter || '')+'"]')
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
      @TodosCollection.each(@addOne, @)

    filterOne: (todo)->
      todo.trigger 'visible'

    filterAll: ()->
      @TodosCollection.each(@filterOne, @)

    newAttributes: ()->
      title: @$input.val().trim()
      order: @TodosCollection.nextOrder()
      completed: false

    createOnEnter: (e)->
      if !(e.which != Common.ENTER_KEY || !@$input.val().trim())
        @TodosCollection.create @newAttributes()
        @$input.val ''

    clearCompleted: ()->
      _.invoke @TodosCollection.completed(), 'destroy'
      false

    toggleAllComplete: ()->
      completed = @allCheckbox.checked
      @TodosCollection.each (todo)->
        todo.save 'completed': completed

