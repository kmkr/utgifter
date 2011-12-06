categories = null
series = null
chart = null

@module "utgifter", ->
  @module "charts", ->
    @module "bar", ->
      @update = (keyfunction) ->
        categories = getCategories(transactions, keyfunction)
        series = getSeries(transactions, transactionGroups, keyfunction)
        unless chart
          chart = new utgifter.charts.bar.BarChart(categories, series)
        else
          chart.update(categories, series)

    @monthKeyfunction = (date) ->
      months = ["Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Des"]
      date.getFullYear() + "/" + months[date.getMonth()]

    @yearKeyfunction = (date) ->
      date.getFullYear()


initializeChart = (keyfunction) ->
  $.get('/transactions', (transactions) =>
    @transactions = transactions
    $.get('/transaction_groups', (transactionGroups) =>
      @transactionGroups = transactionGroups
      utgifter.charts.bar.update(keyfunction)
    )
  )


getCategories = (transactions, keyfunction) ->
  categories = []

  for transaction in transactions
    key = keyfunction(new Date(transaction.time))
    categories.push key if key not in categories

  categories


getTransactionSumForGroup = (transactionGroup, transactions, keyfunction) ->
  sums = { }

  $.each(transactions, ->
    key = keyfunction(new Date(@time))
    sums[key] = 0 unless sums[key]

    if @description.match(new RegExp(transactionGroup.regex, 'i'))
      sums[key] += Math.abs(parseInt(@amount, 10))
      console.log("%s hører til %s", @description, transactionGroup.title)
  )
  sumArray = []
  sumArray.push(value) for own key, value of sums
  sumArray

getSeries = (transactions, transactionGroups, keyfunction) ->
  series = []
  $.each(transactionGroups, ->
    sumArray = getTransactionSumForGroup(@, transactions, keyfunction)
    series.push({
      name: @title
      data: sumArray
    })
  )
  series

$(->
  initializeChart(utgifter.charts.monthKeyfunction) unless $('#chartContainer').length == 0
  $('#chart-by-month').click(-> utgifter.charts.bar.update(utgifter.charts.monthKeyfunction))
  $('#chart-by-year').click(-> utgifter.charts.bar.update(utgifter.charts.yearKeyfunction))


)
