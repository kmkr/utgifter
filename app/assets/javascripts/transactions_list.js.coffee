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

        forms = $(@).find('form')
        forms.hide()
        forms[fromTransaction...toTransaction].show()

        currentPage = newPage
    )
)(jQuery)

$(->
  $('#transaction-list').transactionList()

  $('#transaction-list form').bind('ajax:success', ->
    $(@).effect('highlight')
  )
  $('a.delete_transaction').bind('ajax:success', ->
    $(@).closest('form').hide('slow', -> $(@).remove())
  )
)
