class utgifter.views.LastAddedTransactionsView extends Backbone.View
  template: JST["last_added_transactions/index"]

  transactionsShown: 8 # initial amount of transactions to show

  initialize: ->
    @collection.bind('change', @renderAndShow)

  events:
    "click p.expand"            : "toggleContent"
    "click div.controls p"      : "appendRows"

  getLastTransactionsAsHtml: (from, to) ->
    lastTransactions = ""
    for transaction in @collection.byNewestTransaction(from, to)
      lastTransactions += "<tr>#{JST["transactions/show"](transaction)}</tr>"

    lastTransactions

  appendRows: ->
    amountOfTransactionsToShow = @transactionsShown + 8
    html = @getLastTransactionsAsHtml(@transactionsShown, amountOfTransactionsToShow)
    @transactionsShown = amountOfTransactionsToShow
    $(@el).find("tbody").append(html)

  toggleContent: ->
    $(@el).find(".content").toggle('blind')

  renderAndShow: =>
    @render()
    $(@el).find(".content").show()
    $(@el).find(".content .last-transactions table td").effect('highlight', { color: '#30D8F0' })

  render: ->
    $(@el).html(@template)
    $(@el).find(".last-transactions").html(JST["transactions/table"]())
    $(@el).find("tbody").append(html = @getLastTransactionsAsHtml(0, @transactionsShown))
    @

