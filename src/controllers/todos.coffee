mongoose  = require('mongoose')
TodoModel = mongoose.model('todo')

module.exports = (io)->
  all: (req,resp)->
    TodoModel.where('session',null)
    .exec (err,todos)->
        return resp.send(todos) if not err
        console.log err


  getBySession: (req,resp)->
    id = mongoose.Types.ObjectId(req.params.id)
    TodoModel.where('session',id)
    .exec (err,todos)->
        return resp.send todos if not err
        console.log err


  new: (req,resp)->
    todo = new TodoModel
      title: req.body.title
      completed: req.body.completed
      session: req.body.session

    todo.save (err)->
      if not err
        console.log "todo created"
      console.log err

    io.sockets.emit 'add',todo
    resp.send todo


  get: (req,resp)->
    return TodoModel.findById req.params.id,(err,todo)->
      resp.send todo if not err
      console.log err

  update: (req,resp)->
    TodoModel.findById req.params.id,(err,todo)->
      console.log err if err
      todo.title = req.body.title
      todo.completed = req.body.completed

      todo.save (err)->
        console.log 'todo updated' if not err
        console.log err

      io.sockets.emit 'update',todo
      resp.send todo

  delete: (req,resp)->
    TodoModel.findById req.params.id,(err,todo)->
      todo.remove (err)->
        console.log "todo removed" if not err
        console.log err
      io.sockets.emit 'remove',todo if not err
      resp.send(todo)