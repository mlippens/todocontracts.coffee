define ['contracts-js','backbone','models/session'], (C,Backbone,Session)->
  class Sessions extends Backbone.Collection
    model: Session

    url: 'rest/sessions'


  new Sessions()