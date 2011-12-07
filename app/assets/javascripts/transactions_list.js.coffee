(($) ->
  $.fn.transactionList = ->
    return @each(->
      currentPage = 0
      transactionLimit = 2

      $.get('/transactions', (transactions) =>
        # fetch transactions
        @transactions = transactions
        
        # build pagination
        text = ""
        for i in [0...Math.ceil(@transactions.length / transactionLimit)]
          text += "<span class='page' data-page='#{i}'>#{i+1}</span>"

        $(@).find(".pagination").html(text)
        $(@).find(".pagination .page").click(->
          paginate(parseInt($(@).attr('data-page'), 10))
        )

        paginate(0)
      )
      paginate = (newPage) =>
        fromTransaction = newPage * transactionLimit
        toTransaction = fromTransaction + transactionLimit
        currentTransactions = @transactions[fromTransaction...toTransaction]

        html = ""
        for transaction in currentTransactions
          html += "<div>#{transaction.time} #{transaction.description} #{transaction.amount} Slett Oppdater</div>"
        $(@).find('.transactions').html(html)
        currentPage = newPage
    )
)(jQuery)

$(->
  $('#transaction-list').transactionList()
)
