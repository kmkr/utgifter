class utgifter.views.LastAddedTransactionsView extends Backbone.View
  template: JST["last_added_transactions/index"]

  transactionsShown: 8 # initial amount of transactions to show

  initialize: ->
    @collection.bind('change', @renderAndHighlight)

  events:
    "click p.expand"            : "toggleContent"
    "click div.controls p"      : "appendRows"

  getLastTransactionsAsHtml: (from, to) ->
    lastTransactions = ""
    for transaction in @collection.byNewestTransaction(from, to)
      lastTransactions += "<tr>#{JST["transactions/show"]({model : transaction})}</tr>"

    lastTransactions

  appendRows: ->
    amountOfTransactionsToShow = @transactionsShown + 8
    html = @getLastTransactionsAsHtml(@transactionsShown, amountOfTransactionsToShow)
    @transactionsShown = amountOfTransactionsToShow
    $(@el).find("tbody").append(html)
    $(@el).find("tbody td a.delete-transaction").remove() # no support for deletion in this view yet

  toggleContent: ->
    $(@el).find(".content").toggle('blind')

  renderAndHighlight: =>
    @renderRows()
    $(@el).find("tbody tr:nth-child(1) td").effect('highlight', { color: '#30D8F0' })

  renderRows: ->
    $(@el).find("tbody").html(@getLastTransactionsAsHtml(0, @transactionsShown))
    $(@el).find("tbody td a.delete-transaction").remove() # no support for deletion in this view yet

  render: ->
    $(@el).html(@template)
    $(@el).find(".last-transactions").html(JST["transactions/table"]())
    @renderRows()
    @


  leave: ->
    @collection.unbind('change', @renderAndHighlight)
