initializeChart = () ->
  result = utgifter.charts.dataGenerator(utgifter.data.transactions, "yearly")
  new utgifter.charts.bar.BarChart(result.categories, result.series)

$(->
  $.get('/transactions', (transactions) ->
    utgifter.data.transactions = transactions
    $.get('/transaction_groups', (transactionGroups) ->
      utgifter.data.transactionGroups = transactionGroups
      initializeChart() unless $('#chartContainer').length == 0
      $('#transaction-list').transactionList()
      $('#transaction-list form').bind('ajax:success', ->
        $(@).effect('highlight')
      )
      $('a.delete_transaction').bind('ajax:success', ->
        $(@).closest('form').hide('slow', -> $(@).remove())
      )
    )
  )
  $('.transaction-time').datepicker({ dateFormat: 'yy-mm-dd' })

)
