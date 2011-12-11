class window.utgifter.views.NewTransactionBatchView extends Backbone.View
  template: JST['transaction_batches/new']

  events:
    "ajax:success #new_transaction_batch"     : "writeTransactions"
    "click #submit-all"                       : "submitAll"

  writeTransactions: (evt, response) ->
    for item in response
      transaction = new utgifter.models.Transaction(item)
      view = new utgifter.views.TransactionBatchEntryView({collection: @collection, model: transaction})
      $(@el).find(".transactions").append(view.render().el)

  submitAll: (evt) ->
    $('form.transaction input.submit-transaction').click()
    evt.preventDefault()

  render: ->
    $(@el).html(@template)
    @
