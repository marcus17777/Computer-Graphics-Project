class CANNON.Group
  constructor: (objects) ->
    this.objects = objects || []

  update: () ->
    for obj in this.objects
      if typeof obj.update == 'function'
        obj.update()

  add: (body) ->
    this.objects.push body


millis = () ->
  (new Date).getTime()


toRad = (degrees) ->
  Math.PI * 2 * degree / 360



class @HttpClient
  constructor: () ->

  get: (url, callback) ->
    httpRequest = new XMLHttpRequest
    httpRequest.onreadystatechange = () ->
      if httpRequest.readyState == 4 && httpRequest.status == 200
        callback httpRequest.responseText

    httpRequest.open 'GET', url, true
    httpRequest.send null


Array::last ?= () ->
  return this[this.length - 1]

Array::randomChoice ?= () ->
  this[Math.floor(this.length * Math.random())]

Function::property ?= (prop, desc) ->
  Object.defineProperty @::, prop, desc
