exports = (app,sessions,todos)->
  app.get     'rest',(req,resp)->resp.send "rest service running!"

  app.get     'rest/sessions',sessions.all
  app.get     'rest/sessions/:id',sessions.get
  app.post    'rest/sessions',sessions.new
  app.put     'rest/sessions/:id',sessions.update
  app.delete  'rest/sessions/:id',sessions.delete

  app.get     'rest/todos',todos.all
  app.get     'rest/todos/session/:id',todos.getBySession
  app.post    'rest/todos',todos.new
  app.get     'rest/todos/:id',todos.get
  app.put     'rest/todos/:id',todos.update
  app.delete  'rest/todos/:id',todos["delete"]