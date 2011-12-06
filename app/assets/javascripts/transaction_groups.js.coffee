$(->
  $('#transactions input.submit-transaction').live('click', (evt) ->
    form = $(@).closest('form')

    data =
      transaction:
        time: form.find('.time').val()
        amount: form.find('.amount').val()
        description: form.find('.description').val()
        transaction_group_id: form.find('.transaction_groups').find(':selected').val()

    $.post('/transactions', data, =>
      form.highlight('slow', '0.5', -> $(@).remove())
    )
    
    evt.preventDefault()
  )

  $('#new_transaction_group').bind('ajax:success', ->
    $(@)[0].reset()
    $(@).after('Lagt til')
  )
  $('form.edit_transaction_group').bind('ajax:success', -> $(@).effect('highlight'))
  $('a.delete-transaction-group').bind('ajax:success', ->
    $(@).closest('form').hide('slow', -> $(@).remove())
  )
)
