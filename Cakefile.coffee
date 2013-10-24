fs				= require 'fs'
path			= require 'path'
{spawn, exec}	= require 'child_process'
{print}			= require 'sys'

src				= front: 'src/coffee'


coffee			= 'coffee'
coffee_args		= ["-c","-C"]

sh = (cmd, cb) ->
  proc = exec cmd, (err, stdout, stderr) ->
    process.stdout.write stdout if stdout
    process.stderr.write stderr if stderr
    throw err if err
    process.exit proc.exitCode if proc.exitCode
    cb? proc

bindPrintToListeners = (obj)->
  obj.stdout.on 'data', (data)->
    print data.toString()
  obj.stderr.on 'data', (data)->
    process.stderr.write data.toString()

compileCoffee = (file) ->
  spawn 'coffee', coffee_args.concat([file])

compileCoffeeFolders = (src)->
  args = coffee_args
  args = args.concat([src])
  coffee_exec = spawn coffee, args
  bindPrintToListeners coffee_exec


task 'build', 'build all assets',()->
  compileCoffeeFolders src


task 'watch', 'Watch source files for changes',()->
  coffee_exec = spawn coffee, coffee_args.concat(['-w','-o',dst.front,src.front])
  bindPrintToListeners coffee_exec
  index_exec = spawn coffee, coffee_args.concat(['-w','index.coffee'])
  bindPrintToListeners index_exec



