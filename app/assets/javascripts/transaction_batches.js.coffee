validate = ->
  e = $(@)
  if e.val().length == 0
    e.addClass('has-errors')
  else
    e.removeClass('has-errors')
  
$(->
  $('#new_transaction_batch').bind('ajax:success', (target, transactions) ->
    $.each(transactions, (index, transaction) ->
      transaction_html = $(tmpl('transaction', transaction))
      for error in transaction.errors
        transaction_html.find('input[data-type=' + error + ']').addClass("has-errors")
        transaction_html.find('input').keyup(validate).change(validate)

      $('#transactions').append(transaction_html)
    )
    $('.transaction-time').datepicker({ dateFormat: 'yy-mm-dd' })

    $('#transactions input[type=submit]').show('slow')
  )

  $('#submit-all').click((evt) ->
    $('form.transaction input.submit-transaction').click()
    evt.preventDefault()
  )

)
