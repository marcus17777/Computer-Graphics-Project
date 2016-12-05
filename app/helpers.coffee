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
