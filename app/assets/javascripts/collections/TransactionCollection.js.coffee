class utgifter.collections.TransactionCollection extends Backbone.Collection
  model: window.utgifter.models.Transaction
  url: "/transactions"

  getYears: ->
    years = []
    @forEach((transaction) ->
      year = new Date(transaction.get('time')).getFullYear()
      years.push(year) if $.inArray(year, years) == -1
    )
    
    years

  byYear: (year) ->
    @filter((transaction) ->
      return new Date(transaction.get("time")).getFullYear() == year
    )

  byNewestTransaction: (from = 0, to = @collection.length) ->
    @sortBy((transaction) -> -transaction.get('created_at')).slice(from, to)
