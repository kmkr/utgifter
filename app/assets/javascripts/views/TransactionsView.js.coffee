class window.utgifter.views.TransactionsView extends Backbone.View
  template: JST['transactions/index']

  render: ->
    $(@el).html(@template)
    transactionsContainer = $(@el).find(".transactions")
    @collection.each((transaction) ->
      transactionView = new utgifter.views.TransactionView({model: transaction, collection: @collection})
      transactionsContainer.append(transactionView.render().el)
    )
    @
