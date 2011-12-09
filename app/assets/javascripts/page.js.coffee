$(->
  $('nav a').click(->
    $('nav a').removeClass('active')
    $(@).addClass('active')
  )
)

