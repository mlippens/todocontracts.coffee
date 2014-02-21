app_root  = __dirname
express   = require('express')
path      = require('path')
mongoose  = require('mongoose')
fs        = require('fs')
io        = require('socket.io')
config    = require('./src/config/config')

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
io = io.listen(app.listen(config.port,->console.log "Listening on port #{config.port}"))

mongoose.connect 'mongodb://'+config.host+'/'+config.db
require('./src/config/routes')(app,io)







