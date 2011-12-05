class ChartData
  constructor: (@categories, @dataseries) ->

updateChart = ->
  $.get('/transactions', (transactionResponse) =>
    $.get('/transaction_groups', (transactionGroupResponse) =>
      chartData = getChartData(transactionResponse, transactionGroupResponse)
      new utgifter.BarChart(chartData.categories, chartData.dataseries)
    )
  )

getYearMonth = (time) ->
  date = new Date(time)
  date.getFullYear() + "/" + date.getMonth()


getCategories = (transactions) ->
  categories = []
  categories.push getYearMonth(transaction.time) for transaction in transactions when getYearMonth(transaction.time) not in categories
  categories


getTransactionSumForGroup = (transactionGroup, transactions) ->
  sums = { }

  $.each(transactions, ->
    yearMonth = getYearMonth(this.time)
    sums[yearMonth] = 0 unless sums[yearMonth]

    if this.description.match(new RegExp(transactionGroup.regex, 'i'))
      sums[yearMonth] += Math.abs(parseInt(this.amount, 10))
      console.log("%s hører til %s", this.description, transactionGroup.title)
  )
  sumArray = []
  sumArray.push(value) for own key, value of sums
  sumArray

getSeriesData = (transactions, transactionGroups) ->
  seriesData = []
  $.each(transactionGroups, ->
    sumArray = getTransactionSumForGroup(this, transactions)
    seriesData.push({
      name: this.title
      data: sumArray
    })
  )
  seriesData


getChartData = (transactions, transactionGroups) ->
  categories = getCategories(transactions)
  seriesData = getSeriesData(transactions, transactionGroups)

  new ChartData(categories, seriesData)


$(->
  updateChart() unless $('#chartContainer').length == 0
)
