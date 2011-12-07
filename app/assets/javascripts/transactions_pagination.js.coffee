$(->

  updateTransactionList = () ->
    $.get('/transactions?from=0', (tranactions) =>
      console.log(transactions)
      #$('#transactions').html(transactions)
    )

  updateTransactionList() if $('#transactions').length > 0
)
