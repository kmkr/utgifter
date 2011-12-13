class utgifter.views.NewTransactionBatchView extends Backbone.View
  template: JST['transaction_batches/new']

  views: []

  events:
    "ajax:success #new_transaction_batch"     : "writeTransactions"
    "click #submit-all"                       : "submitAll"

  writeTransactions: (evt, response) =>
    for item in response
      transaction = new utgifter.models.Transaction(item)
      view = new utgifter.views.TransactionBatchEntryView({collection: @collection, model: transaction, errors: item.errors})
      @views.push(view)
      $(@el).find(".transactions-to-add").append(view.render().el)

  submitAll: (evt) ->
    $('form.transaction input.submit-transaction').click()
    evt.preventDefault()

  render: ->
    $(@el).html(@template)
    view = new utgifter.views.LastAddedTransactionsView({collection: @collection})
    @views.push(view)
    $(@el).find(".last-transactions-wrapper").html(view.render().el)
    @
