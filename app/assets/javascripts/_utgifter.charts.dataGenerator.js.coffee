@module "utgifter", ->
  @module "charts", ->
    # Supply the array of transaction models
    # Supply the requested frequency for the result, one of:
    # yearly,
    # monthly, or
    # daily
    @dataGenerator = (transactions, frequency) ->
      # The keyFunction will be used for the y axis keys
      keyFunction = getKeyFunction(frequency)

      # legg til/skriv over transactionGroups på hver transaksjon
      resetTransactionGroups(transactions)

      # finn kategorier (y-akse) basert på frequency
      categories = getCategories(transactions, keyFunction)

      # always use the same transactionGroups
      transactionGroups = utgifter.collections.transactionGroupCollection

      # finn dataseries basert på frequency
      # series are objects with:
      # 1) a name (transaction group name)
      # 2) arrays with values linking to each of the categories
      series = getSeries(transactions, transactionGroups.models, keyFunction, utgifter.charts.helpers.descriptionMatchFunction)
      # The transactions that are not linked to a transaction group. The array returned has length the same as transactionGroups
      otherIncomeSeries = getSeries(transactions, [ new utgifter.models.Transaction({ title: "Andre inntekter" })], keyFunction, utgifter.charts.helpers.positiveAmountAndNoTransactionGroupsMatchFunction)
      otherExpenseSeries = getSeries(transactions, [ new utgifter.models.Transaction({ title: "Andre utgifter" })], keyFunction, utgifter.charts.helpers.negativeAmountAndNoTransactionGroupsMatchFunction)

      series.push(otherIncomeSeries[0])
      series.push(otherExpenseSeries[0])

      return { categories: categories, series: series }


    getKeyFunction = (frequency) ->
      switch frequency
        when "yearly" then utgifter.charts.helpers.yearKeyFunction
        when "monthly" then utgifter.charts.helpers.monthKeyFunction
        when "daily" then utgifter.charts.helpers.dayKeyFunction


    getSeries = (transactions, transactionGroups, keyFunction, matchfunction) ->
      mySeries = []
      for transactionGroup in transactionGroups
        transactionsForGroup = getTransactionsForGroup(transactionGroup, transactions, matchfunction)
        sumArray = getTransactionSum(transactionsForGroup, keyFunction)
        mySeries.push({
          name: transactionGroup.attributes.title
          data: sumArray
          transactionsInSerie: transactionsForGroup
        })

      mySeries

    resetTransactionGroups = (transactions) ->
      for transaction in transactions
        transaction.attributes.transactionGroups = []
    
    getCategories = (transactions, keyFunction) ->
      myCategories = []
      for transaction in transactions
        # calculate the key
        key = keyFunction(new Date(transaction.attributes.time))
        myCategories.push key if key not in myCategories
      
      myCategories
    
    
    getTransactionSum = (transactions, keyFunction) ->
      sums = { }
    
      for transaction in transactions
        key = keyFunction(new Date(transaction.attributes.time))
        sums[key] = 0 unless sums[key]
        sums[key] += parseInt(transaction.attributes.amount, 10)
    
      sumArray = []
      sumArray.push(value) for own key, value of sums
      sumArray
    
    getTransactionsForGroup = (transactionGroup, transactions, matchfunction) ->
      transactionsForGroup = []
      for transaction in transactions
        if matchfunction(transaction, transactionGroup)
          transaction.attributes.transactionGroups.push(transactionGroup)
          transactionsForGroup.push(transaction)
    
      transactionsForGroup
 
 
