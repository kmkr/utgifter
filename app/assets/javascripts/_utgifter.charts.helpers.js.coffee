@module "utgifter", ->
  @module "charts", ->
    @module "helpers", ->
      @months = ["Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Des"]

      @yearKeyFunction = (date) ->
        date.getFullYear()

      @dayKeyFunction = (date) =>
        "#{date.getFullYear()}/#{@months[date.getMonth()]}/#{date.getDay()}"

      @monthKeyFunction = (date) =>
        "#{date.getFullYear()}/#{@months[date.getMonth()]}"

      @descriptionMatchFunction = (transaction, transactionGroup) ->
        transaction.get('description').match(new RegExp(transactionGroup.get('regex'), 'i'))

      @positiveAmountAndNoTransactionGroupsMatchFunction = (transaction, transactionGroup) ->
        transaction.get('transactionGroups').length is 0 and transaction.get('amount') >= 0

      @negativeAmountAndNoTransactionGroupsMatchFunction = (transaction, transactionGroup) ->
        transaction.get('transactionGroups').length is 0 and transaction.get('amount') < 0
