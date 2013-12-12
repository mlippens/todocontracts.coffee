define ['underscore','backbone'],(_,Backbone)->
  class Item extends Backbone.Model
    defaults:
      part1: "Hello"
      part2: "Backbone"

  Item