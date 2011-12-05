$(->
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
    sum = 0
    $.each(transactions, ->
      sum += Math.abs(parseInt(this.amount, 10)) if this.description.match(transactionGroup.regex)
      if this.description.match(transactionGroup.regex)
        console.log(this.description + " matches " + transactionGroup.regex + ". plusset på " + this.amount + " sum er nå " + sum)
    )

    sum

  getSeriesData = (transactions, transactionGroups) ->
    response = []
    $.each(transactionGroups, ->
      sum = getTransactionSumForGroup(this, transactions)
      response.push({
        name: this.title
        data: [ sum ]
      })
    )

    response
)
