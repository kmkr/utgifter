$(->
  $('#transactions input.submit-transaction').live('click', (evt) ->
    form = $(@).closest('form')

    data =
      transaction:
        time: form.find('input[name=time]').val()
        amount: form.find('input[name=amount]').val()
        description: form.find('input[name=description]').val()

    $.post('/transactions', data, =>
      form.hide('slideUp', '0.5', -> $(@).remove())
    )
    
    evt.preventDefault()
  )

  $('#new_transaction_group').bind('ajax:success', ->
    $(@)[0].reset()
    $(@).effect('highlight')
  )
  $('form.edit_transaction_group').bind('ajax:success', -> $(@).effect('highlight'))
  $('a.delete-transaction-group').bind('ajax:success', ->
    $(@).closest('form').hide('slow', -> $(@).remove())
  )
)
