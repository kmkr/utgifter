$(->
  $('#login-fields').dialog({
    autoOpen: true,
    title: 'Logg inn',
    show: { effect: 'drop', direction: 'down', duration: 700, easing: 'easeOutElastic' },
    hide: { effect: 'drop', direction: 'down', duration: 400 },
    width: 600,
    height: 400,
    draggable: false,
    resizeable: false
  })
)
