define ['backbone','underscore'],(Backbone,_)->
  class ItemView extends Backbone.View
    tagName: 'li'

    initialize:()->
      _.bindAll @

    render: ->
      $(@el).html "<span>#{@model.get 'part1'} #{@model.get 'part2'}!</span>"
      @

  ItemView