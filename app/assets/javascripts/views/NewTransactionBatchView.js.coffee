class utgifter.views.NewTransactionBatchView extends Backbone.View
  template: JST['transaction_batches/new']
  lastTransactionsShown: 0

  events:
    "ajax:success #new_transaction_batch"     : "writeTransactions"
    "click #submit-all"                       : "submitAll"
    "click p.expand"                          : "toggleLastTransactionContent"
    "click div.controls p"                    : "increaseNumberOfLastTransactions"

  writeTransactions: (evt, response) ->
    for item in response
      transaction = new utgifter.models.Transaction(item)
      view = new utgifter.views.TransactionBatchEntryView({collection: @collection, model: transaction})
      $(@el).find(".transactions").append(view.render().el)

  submitAll: (evt) ->
    $('form.transaction input.submit-transaction').click()
    evt.preventDefault()


  getLastTransactionsAsHtml: (from, to) ->
    lastTransactions = ""
    for transaction in @collection.byNewestTransaction(from, to)
      lastTransactions += "<tr>#{JST["transactions/show"](transaction)}</tr>"

    lastTransactions

  increaseNumberOfLastTransactions: ->
    amountOfTransactionsToShow = @lastTransactionsShown + 8
    html = @getLastTransactionsAsHtml(@lastTransactionsShown, amountOfTransactionsToShow)
    @lastTransactionsShown = amountOfTransactionsToShow
    $(@el).find(".content .last-transactions tbody").append(html)

  toggleLastTransactionContent: ->
    $(@el).find(".last-transactions-wrapper .content").toggle('blind')

  render: ->
    $(@el).html(@template)
    $(@el).find(".content .last-transactions").append($(JST["transactions/table"]()))
    @increaseNumberOfLastTransactions()
    @
