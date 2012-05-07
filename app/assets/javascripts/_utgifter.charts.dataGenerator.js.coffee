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

      # Denne (eller funksjonen over) har en bug som fører til at for måneder
      # som ikke har inntekt eller utgift vil series-arrayet mangle data for
      # den måneden, og arrayet 'forskyves'. Eks: hvis man har utgifter i "mai"
      # men ikke inntekter vil april-inntektene listes som mai-inntekt.
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



    addNonGroupedTransactionsToSeries = (transactions, keyFunction, useOnlyPositiveValues, series, skiplists, nonGroupedIncomesText, nonGroupedExpensesText) ->
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

      sumOtherIncomes = sumTransactions(otherIncomeTransactions, keyFunction, useOnlyPositiveValues)
      sumOtherExpenses = sumTransactions(otherExpenseTransactions, keyFunction, useOnlyPositiveValues)

      addSerie(nonGroupedIncomesText, sumOtherIncomes, otherIncomeTransactions, series)
      addSerie(nonGroupedExpensesText, sumOtherExpenses, otherExpenseTransactions, series)



    getSeries = (transactionGroups, keyFunction, skiplists, useOnlyPositiveValues) ->
      series = []

      for transactionGroup in transactionGroups
        unless transactionGroup in skiplists
          sums = sumTransactions(transactionGroup.transactions, keyFunction, useOnlyPositiveValues)
          addSerie(transactionGroup.get('title'), sums, transactionGroup.transactions, series)

      series



    # Denne har en vesentlig begrensning nå:
    # Dersom en keyfunction returnerer flere sett per transaksjonsgruppe, og to
    # eller flere transaksjonsgrupper ikke er i sync
    # (at f.eks gruppe1: [ 2001: 50, 2002: 100 ] mens gruppe2: [ 2001: 60, 2003: 200 ])
    # så vil ting skli helt feil ut. Dette er foreløpig ikke noe problem
    # ettersom arrayet alltid inneholder én verdi, men vil kjapt bli et problem
    # og er en flaw som da må fikses.
    # Det kan løses ved å gå over transaksjonsgruppene og lage objektene, og så
    # avgjøre hvor man skal "fylle" opp de manglende verdiene med verdien 0
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

      # Denne gjør at arrays aldri blir tomme, men 0 dersom det ikke er noen
      # transaksjoner som passer
      if sumArray.length == 0
        sumArray.push(0)

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
