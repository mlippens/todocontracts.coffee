define ['common','collections/todos','collections/sessions','views/app','proxiedBackbone','views/session'],(Common,Todos,Sessions,AppView,Backbone,SessionView)->
  class Workspace extends Backbone.Router
    routes:
      ''            : 'home'
      'newsession'     : 'newSession'
      'session/:id'  : 'loadSession'
      '*filter'     : 'setFilter'


    home: ()->
      new AppView()

    newSession: ()->
      new SessionView()

    loadSession: (id)->
      Sessions.fetch success: ()->
        session = Sessions.get(id)
        new AppView {model: session}


    setFilter: (param)->
        Common.TodoFilter = param.trim() || ''
        #common space to keep the todos
        Common.todos.trigger 'filter'

  Workspace