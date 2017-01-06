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
