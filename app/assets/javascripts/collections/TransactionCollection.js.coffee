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

  byMonth: (month) ->
    @filter((transaction) ->
      return new Date(transaction.get("time")).getMonth() + 1 == month
    )

  byNewestTransaction: (from = 0, to = @collection.length) ->
    @sortBy((transaction) -> -new Date(transaction.get('created_at')).getTime()).slice(from, to)
