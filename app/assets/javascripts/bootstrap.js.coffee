window.module = (name, fn)->
  if not @[name]?
    this[name] = {}
  if not @[name].module?
    @[name].module = window.module
  fn.apply(this[name], [])

@module "utgifter", ->
  @init = (transactions) ->
    new utgifter.routers.AppRouter()
    $.get("/transactions", (transactions) ->
      utgifter.collections.transactionCollection = new utgifter.collections.TransactionCollection(transactions)
      $.get("/transaction_groups", (transactionGroups) ->
        utgifter.collections.transactionGroupCollection = new utgifter.collections.TransactionGroupCollection(transactionGroups)
        Backbone.history.start()
      )
    )
  @module "views", ->
  @module "collections", ->
  @module "models", ->
  @module "routers", ->

$(->
  utgifter.init()
)
