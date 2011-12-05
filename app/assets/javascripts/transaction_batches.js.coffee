$(->
  $('#new_transaction_batch').bind('ajax:success', (target, transactions) ->
    $.each(transactions, (index, transaction) ->
      transaction_html = tmpl('transaction', transaction)
      $('#transactions').append(transaction_html)
    )

    $('#transactions input[type=submit]').show('slow')
  )

  $('#submit-all').click((evt) ->
    $('form.transaction input.submit-transaction').click()
    evt.preventDefault()
  )

)
