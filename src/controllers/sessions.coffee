mongoose      = require('mongoose')
io            = require('socket.io')
SessionModel  = mongoose.model('session')

exports.all = (req,resp)->
  SessionModel.find (err,sessions)->
    return resp.send(sessions) if not err
    console.log err

exports.new = (req,resp)->
  session = new SessionModel
    name: req.body.name
  session.save (err)->
    console.log 'session created' if not err
    console.log err
  resp.send session

exports.get = (req,resp)->
  SessionModel.findById req.params.id, (err,session)->
    return console.log err if err
    resp.send session

exports.update = (req,resp)->
  SessionModel.findById req.params.id, (err,session)->
    return console.log err if err
    session.title = req.body.name
    session.save (err)->
      console.log 'session updated' if not err
      console.log err
    resp.send session

exports.delete = (req,resp)->
  SessionModel.findById req.params.id, (err,session)->
    return console.log err if err
    session.remove (err)->
      console.log err if err
    resp.send session