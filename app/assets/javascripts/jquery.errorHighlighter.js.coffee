(($) ->
  $.fn.transactionList = ->
    return @each(->
      currentPage = 0
      transactionLimit = 20

      paginate = (newPage) =>
        fromTransaction = newPage * transactionLimit
        toTransaction = fromTransaction + transactionLimit

        forms = $(@).find('form')
        forms.hide()
        forms[fromTransaction...toTransaction].show()
        $('#transaction-list').effect('highlight')

        currentPage = newPage

      transactions = utgifter.data.transactions
      
      # build pagination
      text = ""
      for i in [0...Math.ceil(transactions.length / transactionLimit)]
        text += "<span class='page' data-page='#{i}'>#{i+1}</span>"

      $(@).find(".pagination").html(text)
      $(@).find(".pagination .page").click(->
        paginate(parseInt($(@).attr('data-page'), 10))
      )

      paginate(0)
    )
)(jQuery)
