require.config
  shim:
    underscore:
      exports: '_'
    backbone:
      deps: ['underscore','jquery']
      exports: 'Backbone'
    backboneLocalstorage:
      deps: ['backbone']
      exports: 'Store'
  paths:
    'contracts-js': '../libs/contracts'
    'jquery': '../bower_components/jquery/jquery',
    'underscore': '../bower_components/underscore/underscore',
    'backbone': '../bower_components/backbone/backbone',
    'backboneLocalStorage': '../bower_components/backbone.localStorage/backbone.localStorage',
    'text': '../bower_components/requirejs-text/text'

require ['contracts-js','jquery','backbone','views/app'],(C,$,Backbone,AppView)->
  Backbone.history.start()
  new AppView()
