$(->
  $('#new_transaction_batch').bind('ajax:success', (target, transactions) ->
    $.each(transactions, (index, transaction) ->
      transaction_html = tmpl('transaction', transaction)
      $('#transactions').append(transaction_html)
    )
  )
)
