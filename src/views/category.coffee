define ['backbone','contracts-js','text!templates/category-overview.html'],(Backbone,C,template)->
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


