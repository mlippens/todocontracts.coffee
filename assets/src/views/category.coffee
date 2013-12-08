define ['proxiedBackbone','contracts-js','text!templates/category-overview.html'],(Backbone,C,template)->

  #import from contract system
  #C.import Backbone.View, "Category View"

  class CategoryOverview extends Backbone.View

    el: '#todoapp'

    initialize: ()->
      @$el.html(_.template(template,{}))
      @$input = @.$('#new-todo')
      @$footer = @.$('#footer')
      @$main = @.$('#main')
      @render()


    render: ()->
      @$main.hide()
      @$footer.hide()


