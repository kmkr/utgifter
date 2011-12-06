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
)
