root = exports ? this

backbone = require('restify')
C        = require('contracts-js')
_        = require('underscore')


makeArrContract = (type)->
  (a)-> a.length isnt 'undefined' and typeof a.length is 'number' and (allInstanceOf(a,type) or a.length is 0)

makeArrTypeContract = (t)->
  (a)-> a.length isnt 'undefined' and typeof a.length is 'number' and (allTypeOf(a,t) or a.length is 0)


allTypeOf = (a,type)->
  for i in [0..a.length-1]
    if not (typeof a[i] is type)
      return false
  return true

allInstanceOf = (a,type)->
  for i in [0..a.length-1]
    if not (a[i] instanceof type)
      return false
  return true


Obj = ?!(x)-> _.isObject(x)

Arr = ? {
  length: Num
}

StrArr = ?!makeArrTypeContract("string")

Function = ?(Any)->Any


addressInterface = ? {
  port: Num
  family: Str
  adress: Str
}

Request = ? {
  header: (Str,Str?)-> Any
  accepts: (Str)->Bool
  is: (Str)->Bool
  getLogger: (Str)->Any
  contentLength: Num
  contentType: Str
  href: -> Str
  log: Obj
  id: Str
  path: ()->Str
  query: Str
  secure: Bool
  time: Num
  params: Any
}

Response = ? {
  header: (Str,Any?)->Any
  cache: (Any?,Obj?)->Any
  status: (Num)->Any
  send: (Any?,Any?)->Company
  json: (Any?,Any?)->Company
  code: Num
  contentLength: Num
  charSet: Str
  contentType: Str
  headers: Obj
  statusCode: Num
  id: Str
}

RequestHandler = ?(Request,Response,Function)->Any

Server = ? {
  use: Arr
  post: (Any,RequestHandler)->Any
  patch: (Any,RequestHandler)->Any
  put: (Any,RequestHandler)->Any
  del: (Any,RequestHandler)->Any
  get: (Any,RequestHandler)->Any
  head: (Any,RequestHandler)->Any
  on: (Str,Function)->Any
  name: Str
  version: Str
  log: Obj
  acceptable: StrArr
  url: Str
  address: ()->addressInterface
  listen: (Arr)->Any
  close: (Arr)->Any
  pre: (RequestHandler)->Any
}

ServerOptions = ? {
  certificate: Str?
  key: Str?
  formatters: Obj?
  log: Obj?
  name: Str?
  spdy: Obj?
  version: Str?
  responseTimeHeader: Str?
  responseTimeFormatter: ((Num)->Any)?
}

ClientOptions = ? {
  accept: Str?
  connectTimeout: Num?
  dtrace: Obj?
  gzip: Obj?
  headers: Obj?
  log: Obj?
  retry: Obj?
  signRequest: Function
  url: Str?
  userAgent: Str?
  version: Str?
}

Client = ? {
  get:    (Str,((Any,Request,Response)->Any)?)->Any
  head:   (Str,((Any,Request,Response)->Any)?)->Any
  post:   (Str,Any,((Any,Request,Response,Any)->Any)?)->Any
  put:    (Str,Any,((Any,Request,Response,Any)->Any)?)->Any
  del:    (Str,((Any,Request,Response)->Any)?)->Any
  basicAuth: (Str,Str)->Any
}

#extending contracts should be something easily implemented?
HttpClient = ? {
  get:    (Any?,Function?)->Any
  head:   (Any?,Function?)->Any
  post:   (Any?,Function?)->Any
  put:    (Any?,Function?)->Any
  del:    (Any?,Function?)->Any
  basicAuth: (Str,Str)->Any
}

ThrottleOptions = ? {
  burst: Num?
  rate: Num?
  ip: Bool?
  xff: Bool?
  username: Bool?
  tokensTable: Obj?
  maxKeys: Num?
  overrides: Obj?
}

restify = ? {
  createServer:       (ServerOptions?)->Server
  createJsonClient:   (ClientOptions?)->Client
  createStringClient: (ClientOptions?)->Client

  ConflictError: (Any?) ==> Any
  InvalidArgumentError: (Any?) ==> Any
  ResError: (Any?) ==> Any
  BadDigestError: (Any?) ==> Any
  BadMethodError: (Any?) ==> Any
  BadRequestError: (Any?) ==> Any
  InternalError: (Any?) ==> Any
  InvalidContentError: (Any?) ==> Any
  InvalidCredentialsError: (Any?) ==> Any
  InvalidHeaderError: (Any?) ==> Any
  InvalidVersionError: (Any?) ==> Any
  MissingParameterError: (Any?) ==> Any
  NotAuthorizedError: (Any?) ==> Any
  RequestExpiredError: (Any?) ==> Any
  RequestThrottledError: (Any?) ==> Any
  WrongAcceptError: (Any?) ==> Any

  acceptParser:           (Any)->RequestHandler
  authorizationParser:    ()->RequestHandler
  dateParser:             (Num?)->RequestHandler
  queryParser:            (Obj?)->RequestHandler
  #should be RequestHandlerArr
  urlEncodedBodyParser:   (Obj?)->Arr
  jsonp:                  ()->RequestHandler
  gzipResponse:           (Obj?)->RequestHandler
  bodyParser:             (Obj?)->Arr
  requestLogger:          (Obj?)->RequestHandler
  serveStatic:            (Obj?)->RequestHandler
  throttle:               (ThrottleOptions?)->RequestHandler
  conditionalRequest:     ()->Arr
  auditLogger:            (Obj?)->Function
  fullResponse:           ()->RequestHandler
  defaultResponseHeaders: Any
}

