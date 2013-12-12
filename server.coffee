app_root  = __dirname
express   = require('express')
path      = require('path')
mongoose  = require('mongoose')
io        = require('socket.io')

app = express()

app.use(express.static(path.join(__dirname,'/assets')))
#parses request body and populates request.body
app.use express.bodyParser()
#checks request.body for HTTP method overrides
app.use express.methodOverride()
#perform route lookup based on url and HTTP method
app.use app.router
#Where to serve static content
###app.use(express.static(path.join(__dirname,'/assets')))###
#Show all errors in development
app.use express.errorHandler(dumpExceptions: true, showStack: true)

app.configure = ()->



port = 4711
io = io.listen(app.listen(port,()->
  console.log "Express server listening on port #{port} in #{app.settings.env} mode. Static dir = #{path.join(__dirname,'/assets')}"))




mongoose.connect 'mongodb://localhost/todo_db'

Schema    = mongoose.Schema
ObjectId  = Schema.ObjectId

Todo = new mongoose.Schema
  title: String
  completed: Boolean
  order: Number
  session: {type: ObjectId, ref: 'Session'}

Session = new mongoose.Schema
  name: String

SessionModel = mongoose.model 'Session',Session
TodoModel = mongoose.model 'Todo',Todo


app.get '/rest',(req,resp)->
  resp.send "running!"


app.get '/rest/sessions', (req,resp)->
  SessionModel.find (err,sessions)->
    return resp.send(sessions) if not err
    console.log err

app.post '/rest/sessions', (req,resp)->
  session = new SessionModel
    name: req.body.name
  session.save (err)->
    console.log 'session created' if not err
    console.log err
  resp.send session

app.get 'rest/sessions/:id', (req,resp)->
  SessionModel.findById req.params.id, (err,session)->
    return console.log err if err
    resp.send session

app.put 'rest/sessions/:id', (req,resp)->
  SessionModel.findById req.params.id, (err,session)->
    return console.log err if err
    session.title = req.body.name
    session.save (err)->
      console.log 'session updated' if not err
      console.log err
    resp.send session

app.delete 'rest/sessions/:id', (req,resp)->
  SessionModel.findById req.params.id, (err,session)->
    return console.log err if err
    session.remove (err)->
      console.log err if err
    resp.send session


app.get '/rest/todos',(req,resp)->
  TodoModel.where('session',null)
    .exec (err,todos)->
      return resp.send(todos) if not err
      console.log err


app.get '/rest/todos/session/:id',(req,resp)->
  id = mongoose.Types.ObjectId(req.params.id)
  TodoModel.where('session',id)
    .exec (err,todos)->
      return resp.send todos if not err
      console.log err


app.post '/rest/todos',(req,resp)->
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


app.get '/rest/todos/:id',(req,resp)->
  return TodoModel.findById req.params.id,(err,todo)->
    resp.send todo if not err
    console.log err

app.put '/rest/todos/:id',(req,resp)->
  TodoModel.findById req.params.id,(err,todo)->
    console.log err if err
    todo.title = req.body.title
    todo.completed = req.body.completed

    todo.save (err)->
      console.log 'todo updated' if not err
      console.log err

    io.sockets.emit 'update',todo
    resp.send todo

app.delete '/rest/todos/:id',(req,resp)->
  TodoModel.findById req.params.id,(err,todo)->
    todo.remove (err)->
      console.log "todo removed" if not err
      console.log err
    io.sockets.emit 'remove',todo if not err
