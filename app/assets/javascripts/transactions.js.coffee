categories = null
series = null
chart = null

@module "utgifter", ->
  @module "charts", ->
    @module "bar", ->
      @update = (keyfunction) ->
        resetTransactionGroups(transactions)
        # y axis categories
        categories = getCategories(transactions, keyfunction)

        # series are objects with:
        # 1) a name (transaction group name)
        # 2) arrays with values linking to each of the categories
        series = getSeries(transactions, transactionGroups, keyfunction, utgifter.charts.descriptionMatchFunction)

        # The transactions that are not linked to a transaction group. The array returned has length the same as transactionGroups
        otherIncomeSeries = getSeries(transactions, [{ title: "Andre inntekter" }], keyfunction, utgifter.charts.positiveAmountAndNoTransactionGroupsMatchFunction)
        otherExpenseSeries = getSeries(transactions, [{ title: "Andre utgifter" }], keyfunction, utgifter.charts.negativeAmountAndNoTransactionGroupsMatchFunction)

        series.push(otherIncomeSeries[0])
        series.push(otherExpenseSeries[0])

        unless chart
          chart = new utgifter.charts.bar.BarChart(categories, series)
        else
          chart.update(categories, series)

    @monthKeyfunction = (date) ->
      months = ["Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Des"]
      date.getFullYear() + "/" + months[date.getMonth()]

    @yearKeyfunction = (date) ->
      date.getFullYear()

    @descriptionMatchFunction = (transaction, transactionGroup) ->
      transaction.description.match(new RegExp(transactionGroup.regex, 'i'))

    @positiveAmountAndNoTransactionGroupsMatchFunction = (transaction, transactionGroup) ->
      transaction.transactionGroups.length is 0 and transaction.amount >= 0

    @negativeAmountAndNoTransactionGroupsMatchFunction = (transaction, transactionGroup) ->
      transaction.transactionGroups.length is 0 and transaction.amount < 0


initializeChart = (keyfunction) ->
  $.get('/transactions', (transactions) =>
    @transactions = transactions
    $.get('/transaction_groups', (transactionGroups) =>
      @transactionGroups = transactionGroups
      utgifter.charts.bar.update(keyfunction)
    )
  )


resetTransactionGroups = (transactions) ->
  for transaction in transactions
    transaction.transactionGroups = []


getCategories = (transactions, keyfunction) ->
  myCategories = []
  for transaction in transactions
    # calculate the key
    key = keyfunction(new Date(transaction.time))
    myCategories.push key if key not in myCategories

  myCategories


getTransactionSum = (transactions, keyfunction) ->
  sums = { }

  for transaction in transactions
    key = keyfunction(new Date(transaction.time))
    sums[key] = 0 unless sums[key]
    sums[key] += parseInt(transaction.amount, 10)

  sumArray = []
  sumArray.push(value) for own key, value of sums
  sumArray

getTransactionsForGroup = (transactionGroup, transactions, matchfunction) ->
  transactionsForGroup = []
  for transaction in transactions
    if matchfunction(transaction, transactionGroup)
      transaction.transactionGroups.push(transactionGroup)
      transactionsForGroup.push(transaction)

  transactionsForGroup


getSeries = (transactions, transactionGroups, keyfunction, matchfunction) ->
  mySeries = []
  for transactionGroup in transactionGroups
    transactionsForGroup = getTransactionsForGroup(transactionGroup, transactions, matchfunction)
    sumArray = getTransactionSum(transactionsForGroup, keyfunction)
    mySeries.push({
      name: transactionGroup.title
      data: sumArray
      transactionsForGroup: transactionsForGroup
    })

  mySeries


$(->
  initializeChart(utgifter.charts.monthKeyfunction) unless $('#chartContainer').length == 0
  $('#chart-by-month').click(-> utgifter.charts.bar.update(utgifter.charts.monthKeyfunction))
  $('#chart-by-year').click(-> utgifter.charts.bar.update(utgifter.charts.yearKeyfunction))
  $('.transaction-time').datepicker({ dateFormat: 'yy-mm-dd' })
)
