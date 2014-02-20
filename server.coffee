app_root  = __dirname
express   = require('express')
path      = require('path')
mongoose  = require('mongoose')
fs        = require('fs')
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

mongoose.connect 'mongodb://localhost/todo_db'

models_path = app_root + '/src/models'
fs.readdirSync(models_path).forEach (f)->
  if(~f.indexOf('.js'))
    require(models_path + '/' + f)


require('./src/config/routes')(app)

port = 4711
io = io.listen(app.listen(port,()->
  console.log "Express server listening on port #{port} in #{app.settings.env} mode. Static dir = #{path.join(__dirname,'/assets')}"))






