define ['jquery',
        'underscore',
        'proxiedBackbone',
        'text!templates/todos.html'
        'common'
        'contracts-js'], ($, _, Backbone, todosTemplate, Common, C)->

  #import from contract system
  #C.import Backbone.View, "TodoDetail View"

  class TodoView extends Backbone.View
    tagName: 'li',

    template: _.template(todosTemplate)

    events:
      'click .toggle': 'toggleCompleted',
      'dblclick label': 'edit',
      'click .destroy': 'clear',
      'keypress .edit': 'updateOnEnter',
      'blur .edit': 'close'

    initialize: ()->
      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove
      @listenTo @model, 'visible', @toggleVisible


    render: ()->
      @$el.html(@template(@model.toJSON()))
      @$el.toggleClass('completed', @model.get 'completed')
      @toggleVisible()
      @$input = @.$('.edit')
      @

    toggleVisible: ()->
      @$el.toggleClass('hidden', @isHidden());

    isHidden: ()->
      isCompleted = @model.get 'completed'
      (!isCompleted && Common.TodoFilter == 'completed') ||
      (isCompleted && Common.TodoFilter == 'active')

    toggleCompleted: ()->
      @model.toggle()

    edit: ()->
      @$el.addClass 'editing'
      @$input.focus()

    close: ()->
      value = @$input.val().trim()
      if value
        @model.save title: value
      else
        @clear()
      @$el.removeClass 'editing'

    updateOnEnter: (e)->
      if e.keyCode == Common.ENTER_KEY
        @close()

    clear: ()->
      @model.destroy()

