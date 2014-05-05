root = exports ? this

require.config
  shim:
    #underscore:
    #  exports: '_'
    #backbone:
    #  deps: ['underscore','jquery']
    #  exports: 'Backbone'
    'backbone-relational':
      deps: ['backbone']
    backboneLocalstorage:
      deps: ['backbone']
      exports: 'Store'
  paths:
    #'contracts-js': '../libs/contracts'
    #'jquery': '../bower_components/jquery/jquery',
    #'underscore': '../bower_components/underscore/underscore',
    #'backbone': '../bower_components/backbone/backbone',
    'backbone-relational': '../bower_components/backbone-relational/backbone-relational'
    'backboneLocalStorage': '../bower_components/backbone.localStorage/backbone.localStorage',
    'text': '../bower_components/requirejs-text/text'
    'socketio': '/socket.io/socket.io'
    'proxiedBackbone': 'contracts/bb'

define 'jquery',[],()->
  return jQuery
define 'underscore',[],()->
  return _
define 'backbone',[],()->
  return Backbone
define 'contracts-js',[],()->
  return root['contracts-js']

CONTRACTS_FLAG = true
#contracts switch
if CONTRACTS_FLAG
  define 'proxiedBackbone',["./contracts/bb"],(bb)->
    bb
else
  define 'proxiedBackbone',[],()->
    return root.Backbone

require ['contracts-js','jquery','proxiedBackbone','views/app','router/workspace'],(C,$,Backbone,AppView,Workspace)->
  new Workspace()
  Backbone.history.start()


