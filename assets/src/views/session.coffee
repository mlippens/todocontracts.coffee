define ['jquery',
        'underscore',
        'proxiedBackbone',
        'collections/todos',
        'views/app',
        'collections/sessions',
        'text!templates/session-create.html'],($,_,Backbone,Todos,AppView,Sessions,SessionTemplate)->

  class SessionView extends Backbone.View

    el: '#todocreate',

    events:
      'click #newsession': 'createSession'

    initialize: ()->
      @$el.html(_.template SessionTemplate,{})
      @$app = $('#todoapp')
      @$footer = $('#info')
      @$app.hide()
      @$footer.hide()

    render: ()->
      @$el.show()
      @

    createSession: (e)->
      e.preventDefault()
      session = Sessions.create todos: new Todos(), {
          wait: true,
          success: ()-> Backbone.history.navigate 'session/#{session.id}', {trigger:true}
        }



