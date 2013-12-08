define ['common','collections/todos','views/app','views/category','proxiedBackbone'],(Common,Todos,AppView,CategoryView,Backbone)->
  class Workspace extends Backbone.Router
    routes:
      ''            : 'home'
      'categories'  : 'categoryOverview'
      '*filter'     : 'setFilter'

    home: ()->
      new AppView()

    setFilter: (param)->
        Common.TodoFilter = param.trim() || ''
        Todos.trigger 'filter'

    categoryOverview: ()->
      new CategoryView()



  Workspace