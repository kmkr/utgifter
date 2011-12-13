class utgifter.routers.AppRouter extends Backbone.Router
  routes: {
    ""                            : "index",
    "transactions"                : "transactions",
    "overview/:year/yearly"       : "yearlyOverview",
    "overview/:year/monthly"      : "monthlyOverview",
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

  yearlyOverview: (year) ->
    view = new window.utgifter.views.YearlyOverviewView({collection: utgifter.collections.transactionCollection, year: parseInt(year, 10)})
    @swap(view)
    # the graph must be rendered after the DOM is in place
    view.renderGraph()

  monthlyOverview: (year) ->
    view = new window.utgifter.views.MonthlyOverviewView({collection: utgifter.collections.transactionCollection, year: parseInt(year, 10)})
    @swap(view)
    # the graph must be rendered after the DOM is in place
    view.renderGraph()

  newTransactionBatch: ->
    @swap(new window.utgifter.views.NewTransactionBatchView({collection: utgifter.collections.transactionCollection}))

  transactionGroups: ->
    @swap(new window.utgifter.views.TransactionGroupsView({collection: utgifter.collections.transactionGroupCollection}))

Backbone.View::destroy = ->
  # Destroy sub views
  if @views
    console.log("Lengde på sub views: %o %o", @views.length, @)
    for view in @views
      view.destroy()
    @views.length = 0

  # Unbind all callbacks on @collection
  @collection.unbind() if @collection
  
  # Unbind all callbacks on @model
  @model.unbind() if @model

  @unbind()
  
  # Perform internal view cleanup
  @leave() if @leave
  
  # Remove the view from the DOM.
  # This will also remove events bound to the view's private DOM-element (@el)
  @remove()
