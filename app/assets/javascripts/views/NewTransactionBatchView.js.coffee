class utgifter.views.NewTransactionBatchView extends Backbone.View
  template: JST['transaction_batches/new']

  views: []

  events:
    "ajax:success #new_transaction_batch"     : "writeTransactions"
    "click #submit-all"                       : "submitAll"
    "change #transaction_batch_parser"        : "openBatchContentArea"

  openBatchContentArea: ->
    $(@el).find("#transaction_batch_content").show('blind')
    $(@el).find(".new_transaction_batch input[type=submit]").show('fade')


  writeTransactions: (evt, response) =>
    for item in response
      transaction = new utgifter.models.Transaction(item)
      view = new utgifter.views.TransactionCandidateView({collection: @collection, model: transaction})
      @views.push(view)

      addTo = @getDomLocationToAdd(transaction)
      $(@el).find(addTo).append(view.render().el)
      $(@el).find("#{addTo} form").last().show('blind')

    $(@el).find("#submit-all").show()

  getDomLocationToAdd: (transaction) ->
    if transaction.isPossibleDuplicate()
      console.log("duplicate transaction #{transaction.get('errors')}")
      ".possible-duplicated-transactions"
    else if transaction.get('errors')?.length > 0
      console.log("error in transaction #{transaction.get('errors')}")
      ".parse-error-transactions"
    else
      ".successfully-parsed-transactions"

  submitAll: (evt) ->
    $('form.transaction input.submit-transaction').click()
    evt.preventDefault()

  render: ->
    $(@el).html(@template)
    view = new utgifter.views.LastAddedTransactionsView({collection: @collection})
    @views.push(view)
    $(@el).find(".last-transactions-wrapper").html(view.render().el)
    @
