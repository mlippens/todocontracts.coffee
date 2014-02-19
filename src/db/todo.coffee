mongoose = require('mongoose')

Schema    = mongoose.Schema
ObjectId  = Schema.ObjectId

Todo = new mongoose.Schema
  title: String
  completed: Boolean
  order: Number
  session: {type: ObjectId, ref: 'Session'}

mongoose.model 'todo',Todo