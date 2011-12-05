categories = null
series = null

@module "utgifter", ->
  @module "charts", ->
    @module "bar", ->
      @update = (keyfunction) ->
        categories = getCategories(transactions, keyfunction)
        series = getSeries(transactions, transactionGroups, keyfunction)
        new utgifter.charts.bar.BarChart(categories, series)
    @monthKeyfunction = (date) ->
      months = ["Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Des"]
      date.getFullYear() + "/" + months[date.getMonth()]

    @yearKeyfunction = (date) ->
      date.getFullYear()


initializeChart = (keyfunction) ->
  $.get('/transactions', (transactions) =>
    this.transactions = transactions
    $.get('/transaction_groups', (transactionGroups) =>
      this.transactionGroups = transactionGroups
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
    key = keyfunction(new Date(this.time))
    sums[key] = 0 unless sums[key]

    if this.description.match(new RegExp(transactionGroup.regex, 'i'))
      sums[key] += Math.abs(parseInt(this.amount, 10))
      console.log("%s hører til %s", this.description, transactionGroup.title)
  )
  sumArray = []
  sumArray.push(value) for own key, value of sums
  sumArray

getSeries = (transactions, transactionGroups, keyfunction) ->
  series = []
  $.each(transactionGroups, ->
    sumArray = getTransactionSumForGroup(this, transactions, keyfunction)
    series.push({
      name: this.title
      data: sumArray
    })
  )
  series

$(->
  initializeChart(utgifter.charts.monthKeyfunction) unless $('#chartContainer').length == 0
)
