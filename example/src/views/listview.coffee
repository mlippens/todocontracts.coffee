define ['underscore','jquery','backbone','collections/list','models/item','views/itemview'],(_,$,Backbone,List,Item,ItemView)->
  class ListView extends Backbone.View

    el: $ 'body'

    initialize: ()->
      _.bindAll @
      @counter = 0
      @collection = new List()
      @collection.bind('add',@appendItem)
      @render()

    render: ()->
      $(@el).append("<button>Add list item:</button>")
      $(@el).append("<ul></ul>")

    addItem: ()->
      @counter++
      item = new Item()
      item.set('part2',"#{item.get('part2')} #{@counter}")
      @collection.add(item)

    appendItem: (item)->
      item_view = new ItemView model: item
      $('ul').append(item_view.render().el)


    events: 'click button': 'addItem'
  ListView
