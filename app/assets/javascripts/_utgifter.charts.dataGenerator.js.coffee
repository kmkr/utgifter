@module "utgifter", ->
  @module "charts", ->
    @dataGenerator = (options) ->
      settings = $.extend( {
        frequency: 'yearly'
        transactionGroups: utgifter.collections.transactionGroupCollection.models
        transactions: utgifter.collections.transactionCollection.models
        matchFunction: utgifter.charts.helpers.descriptionMatchFunction
        skiplists: utgifter.collections.transactionGroupCollection.onlySkiplists()
        useOnlyPositiveValues: false
        text:
          nonGroupedExpenses: 'Andre utgifter'
          nonGroupedIncomes: 'Andre inntekter'
      }, options)

      # The keyFunction will be used for the y axis keys
      keyFunction = getKeyFunction(settings.frequency)
      
      # finn kategorier (y-akse) basert på frequency
      categories = getCategories(settings.transactions, keyFunction)

      # Legger til transaksjoner i hver gruppe
      setupRelations(settings.transactions, settings.transactionGroups, settings.matchFunction)

      series = getSeries(
        settings.transactionGroups,
        keyFunction,
        settings.skiplists,
        settings.useOnlyPositiveValues
      )
      
      addNonGroupedTransactionsToSeries(settings.transactions, keyFunction, settings.useOnlyPositiveValues, series, settings.skiplists, settings.text.nonGroupedIncomes, settings.text.nonGroupedExpenses)

      return { categories: categories, series: series }



    setupRelations = (transactions, transactionGroups, matchFunction) ->
      for transaction in transactions
        transaction.set({'transactionGroups': []}, {silent: true})

      for transactionGroup in transactionGroups
        transactionGroup.set({'transactions': []}, {silent: true})
        for transaction in transactions
          if matchFunction(transaction, transactionGroup)
            transactionGroup.get('transactions').push(transaction)
            transaction.get('transactionGroups').push(transactionGroup)




    addSerie = (title, sums, transactionsInSerie, series) ->
      series.push({
        name: title
        data: sums
        transactionsInSerie: transactionsInSerie
      })



    addNonGroupedTransactionsToSeries = (transactions, keyFunction, useOnlyPositiveValues, series, skiplists, nonGroupedIncomesText, nonGroupedExpensesText) ->
      otherIncomeTransactions = []
      otherExpenseTransactions = []
      for transaction in transactions when transaction.get('transactionGroups').length is 0
        skip = false
        for skiplist in skiplists
          skip = true if utgifter.charts.helpers.descriptionMatchFunction(transaction, skiplist)

        unless skip
          if transaction.get('amount') > 0
            otherIncomeTransactions.push(transaction)
          else
            otherExpenseTransactions.push(transaction)

      sumOtherIncomes = sumTransactions(otherIncomeTransactions, keyFunction, useOnlyPositiveValues)
      sumOtherExpenses = sumTransactions(otherExpenseTransactions, keyFunction, useOnlyPositiveValues)

      addSerie(nonGroupedIncomesText, sumOtherIncomes, otherIncomeTransactions, series)
      addSerie(nonGroupedExpensesText, sumOtherExpenses, otherExpenseTransactions, series)



    getSeries = (transactionGroups, keyFunction, skiplists, useOnlyPositiveValues) ->
      series = []

      for transactionGroup in transactionGroups
        unless transactionGroup in skiplists
          sums = sumTransactions(transactionGroup.get('transactions'), keyFunction, useOnlyPositiveValues)
          addSerie(transactionGroup.get('title'), sums, transactionGroup.get('transactions'), series)

      series



    sumTransactions = (transactions, keyFunction, useOnlyPositiveValues) ->
      sums = new Object()

      for transaction in transactions
        key = keyFunction(new Date(transaction.get("time")))
        sums[key] = 0 unless sums[key]

        val = parseInt(transaction.get("amount"), 10)
        val = Math.abs(val) if useOnlyPositiveValues
        sums[key] += val
    
      sumArray = []
      sumArray.push(value) for own key, value of sums
      sumArray
    

    
    getCategories = (transactions, keyFunction) ->
      categories = []
      for transaction in transactions
        # calculate the key
        key = keyFunction(new Date(transaction.get("time")))
        categories.push(key) if key not in categories
      
      categories
    


    getKeyFunction = (frequency) ->
      switch frequency
        when "yearly" then utgifter.charts.helpers.yearKeyFunction
        when "monthly" then utgifter.charts.helpers.monthKeyFunction
        when "daily" then utgifter.charts.helpers.dayKeyFunction
