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
      @$sessioninfo = @$el.find('#sessioninfo')
      @$name = @$el.find('input #name')
      @$app.hide()
      @$footer.hide()

    render: ()->
      @$el.show()
      @

    createSession: (e)->
      e.preventDefault()
      name = @$name.val() || "Anonymous todolist"
      that = @
      session = Sessions.create name: name, {
          wait: true,
          success: ->
            console.log session.id
            that.$sessioninfo.html('')
            that.$sessioninfo.html("surf to <a href=\"#/session/#{session.id}\">here</a> to open your todo list!")
        }



