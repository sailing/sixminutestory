#router.js.coffee le´garber-irish method.
this.JSRouter = {
  Register: (path, block) ->
    path = path.split '.'
    controller =
    @[path[0]] ?= {}
    @[path[0]][path[1]] ?= block

  common:
    init: ->
      # application-wide code

}

Util = {
  exec: (controller, action) ->
    ns = JSRouter
    if controller != "" and ns[controller] and typeof ns[controller][action] == "function"
      ns[controller][action]()

  init: ->
    body = document.body
    controller = body.getAttribute "data-controller"
    action = body.getAttribute "data-action"

    Util.exec "common"
    Util.exec controller
    Util.exec controller, action
}

$(document).ready Util.init