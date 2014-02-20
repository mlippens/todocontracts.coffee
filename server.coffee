app_root  = __dirname
express   = require('express')
path      = require('path')
mongoose  = require('mongoose')
fs        = require('fs')
io        = require('socket.io')

port = 4711

models_path = app_root + '/src/models'
fs.readdirSync(models_path).forEach (f)->
  if(~f.indexOf('.js'))
    require(models_path + '/' + f)

app = express()
app.use(express.static(path.join(__dirname,'/assets')))
#parses request body and populates request.body
app.use express.bodyParser()
#Show all errors in development
app.use express.errorHandler(dumpExceptions: true, showStack: true)
app.configure = ->
io = io.listen(app.listen(port,->console.log "Listening on port #{port}"))

mongoose.connect 'mongodb://localhost/todo_db'
require('./src/config/routes')(app,io)







