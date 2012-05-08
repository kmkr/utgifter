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
        categories,
        settings.skiplists,
        settings.useOnlyPositiveValues
      )



      addNonGroupedTransactionsToSeries(settings.transactions, keyFunction, categories, settings.useOnlyPositiveValues, series, settings.skiplists, settings.text.nonGroupedIncomes, settings.text.nonGroupedExpenses)

      console.log("categories: %o, series: %o", categories, series)

      return { categories: categories, series: series }



    setupRelations = (transactions, transactionGroups, matchFunction) ->
      for transaction in transactions
        transaction.transactionGroups = []

      for transactionGroup in transactionGroups
        transactionGroup.transactions = []
        for transaction in transactions
          if matchFunction(transaction, transactionGroup)
            transactionGroup.transactions.push(transaction)
            transaction.transactionGroups.push(transactionGroup)




    addSerie = (title, sums, transactionsInSerie, series) ->
      series.push({
        name: title
        data: sums
        transactionsInSerie: transactionsInSerie
      })



    addNonGroupedTransactionsToSeries = (transactions, keyFunction, categories, useOnlyPositiveValues, series, skiplists, nonGroupedIncomesText, nonGroupedExpensesText) ->
      otherIncomeTransactions = []
      otherExpenseTransactions = []
      for transaction in transactions when transaction.transactionGroups.length is 0
        skip = false
        for skiplist in skiplists
          skip = true if utgifter.charts.helpers.descriptionMatchFunction(transaction, skiplist)

        unless skip
          if transaction.get('amount') > 0
            otherIncomeTransactions.push(transaction)
          else
            otherExpenseTransactions.push(transaction)

      sumOtherIncomes = sumTransactions(otherIncomeTransactions, keyFunction, categories, useOnlyPositiveValues)
      sumOtherExpenses = sumTransactions(otherExpenseTransactions, keyFunction, categories, useOnlyPositiveValues)

      addSerie(nonGroupedIncomesText, sumOtherIncomes, otherIncomeTransactions, series)
      addSerie(nonGroupedExpensesText, sumOtherExpenses, otherExpenseTransactions, series)



    getSeries = (transactionGroups, keyFunction, categories, skiplists, useOnlyPositiveValues) ->
      series = []

      for transactionGroup in transactionGroups
        unless transactionGroup in skiplists
          sums = sumTransactions(transactionGroup.transactions, keyFunction, categories, useOnlyPositiveValues)
          addSerie(transactionGroup.get('title'), sums, transactionGroup.transactions, series)

      series



    sumTransactions = (transactions, keyFunction, categories, useOnlyPositiveValues) ->
      sums = new Object()

      for transaction in transactions
        key = keyFunction(new Date(transaction.get("time")))
        sums[key] = 0 unless sums[key]

        val = parseInt(transaction.get("amount"), 10)
        val = Math.abs(val) if useOnlyPositiveValues
        sums[key] += val
    
      if categories.length != Object.keys(sums).length
        for category in categories
          unless sums[category]
            console.log("Mangler data på nødvendig kategori %s - setter '0'", category)
            sums[category] = 0

      sumArray = []
      for category in categories
        sumArray.push(sums[category])

      sumArray
    


    # Returnerer et aggregert sett med Y-akse-navn for transaksjonene
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
