define ['contracts-js','backbone','models/category','backboneLocalstorage'], (C,Backbone,Category,Store)->
  class Categories extends Backbone.Collection
    model: Category

    localStorage: new Store('categories-storage')


  Categories