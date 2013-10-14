// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'underscore'], function(Backbone, _) {
    var ItemView, _ref;
    ItemView = (function(_super) {
      __extends(ItemView, _super);

      function ItemView() {
        _ref = ItemView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ItemView.prototype.tagName = 'li';

      ItemView.prototype.initialize = function() {
        return _.bindAll(this);
      };

      ItemView.prototype.render = function() {
        $(this.el).html("<span>" + (this.model.get('part1')) + " " + (this.model.get('part2')) + "!</span>");
        return this;
      };

      return ItemView;

    })(Backbone.View);
    return ItemView;
  });

}).call(this);
