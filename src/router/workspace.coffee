define ['common','collections/todos','backbone'],(Common,Todos,Backbone)->
  class Workspace extends Backbone.Router
    routes:
      '*filter': 'setFilter'

    setFilter: (param)->
      Common.TodoFilter = param.trim() || ''
      Todos.trigger 'filter'
  Workspace