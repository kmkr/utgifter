class utgifter.views.NewTransactionBatchView extends Backbone.View
  template: JST['transaction_batches/new']

  views: []

  events:
    "ajax:success #new_transaction_batch"     : "writeTransactions"
    "click #submit-all"                       : "submitAll"
    "change #transaction_batch_parser"        : "openBatchContentArea"

  openBatchContentArea: ->
    $(@el).find("#transaction_batch_content").show('blind')


  writeTransactions: (evt, response) =>
    for item in response
      transaction = new utgifter.models.Transaction(item)
      view = new utgifter.views.TransactionBatchEntryView({collection: @collection, model: transaction, errors: item.errors})
      @views.push(view)
      $(@el).find(".transactions-to-add").append(view.render().el)
      $(@el).find(".transactions-to-add form").last().show('blind')
    $(@el).find("#submit-all").show()

  submitAll: (evt) ->
    $('form.transaction input.submit-transaction').click()
    evt.preventDefault()

  render: ->
    $(@el).html(@template)
    view = new utgifter.views.LastAddedTransactionsView({collection: @collection})
    @views.push(view)
    $(@el).find(".last-transactions-wrapper").html(view.render().el)
    @
