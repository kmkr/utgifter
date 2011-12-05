$(->
  updateChart = ->
    $.get('/transactions', (transactionResponse) =>
      categories = getCategories(transactionResponse)
      $.get('/transaction_groups', (transactionGroupResponse) =>
        series = getSeriesData(transactionResponse, transactionGroupResponse)
        new utgifter.BarChart(categories, series)
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
      sum = sums[getYearMonth(this.time)]
      sums[getYearMonth(this.time)] = 0 unless sum
      sums[getYearMonth(this.time)] += Math.abs(parseInt(this.amount, 10)) if this.description.match(transactionGroup.regex)
    )
    sumArray = []
    sumArray.push(value) for own key, value of sums
    sumArray


  getSeriesData = (transactions, transactionGroups) ->
    response = []
    $.each(transactionGroups, ->
      sumArray = getTransactionSumForGroup(this, transactions)
      response.push({
        name: this.title
        data: sumArray
      })
    )

    response

  updateChart() unless $('#chartContainer').length == 0
)
