mongoose = require('mongoose')

Session = new mongoose.Schema
  name: String

mongoose.model 'session',Session