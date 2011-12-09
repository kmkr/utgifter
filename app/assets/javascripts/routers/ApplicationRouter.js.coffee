class window.utgifter.routers.AppRouter extends Backbone.Router
  routes: {
    ""                            : "index",
    "transactions"                : "transactions",
    "overview/year"               : "yearlyOverview",
    "transaction_batches/new"     : "newTransactionBatch",
    "transaction_groups"          : "transactionGroups"
  }

  swap: (newView) ->
    @view.destroy() if @view
    @view = newView
    $("#main-content").html(@view.render().el)

  index: ->
    @swap(new window.utgifter.views.IndexView())
  
  transactions: ->
    @swap(new window.utgifter.views.TransactionsView({collection: utgifter.collections.transactionCollection}))

  yearlyOverview: ->
    view = new window.utgifter.views.YearlyOverviewView({collection: utgifter.collections.transactionCollection})
    @swap(view)
    # the graph must be rendered after the DOM is in place
    view.renderGraph()

  newTransactionBatch: ->
    @swap(new window.utgifter.views.NewTransactionBatchView())

  transactionGroups: ->
    @swap(new window.utgifter.views.TransactionGroupsView({collection: utgifter.collections.transactionGroupCollection}))

Backbone.View::destroy = ->
  @unbind()
  @remove()
