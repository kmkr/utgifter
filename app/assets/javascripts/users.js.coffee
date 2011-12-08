$(->
  loginModal.init() if $('#login-fields').length > 0
)

loginModal = {
  container: null,
  init: ->
    $("#login-fields").modal({
      overlayId: 'login-fields-overlay',
      containerId: 'login-fields-container',
      close: false,
      minHeight: 80,
      opacity: 65,
      position: ['0',],
      overlayClose: true,
      onOpen: loginModal.open,
    })
  open: (d) ->
    self = this
    self.container = d.container[0]
    d.overlay.fadeIn('slow', ->
      $("#login-fields", self.container).show()
      title = $("#login-fields-title", self.container)
      title.show()
      d.container.slideDown('slow', ->
        showFunction = ->
          h = $("#login-fields-content", self.container).height() + title.height() + 45
          d.container.animate(
            {height: h},
            200,
            -> $("#login-fields-content", self.container).show()
          )
        
        setTimeout(showFunction, 300)
      )
    )
  }

