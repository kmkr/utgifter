class window.utgifter.views.TransactionGroupsView extends Backbone.View
  template: JST['transaction_groups/index']

  initialize: ->
    @collection.bind('add', @render)
    @collection.bind('change', @render)

  renderNew: ->
    dom = $(@el).find(".add-transaction-group")
    dom.html(new utgifter.views.NewTransactionGroupView({collection: @collection}).render().el)

  renderExisting: ->
    dom = $(@el).find(".transaction-groups")
    @collection.each((transactionGroup) ->
      transactionGroupView = new utgifter.views.TransactionGroupView({ model: transactionGroup, collection: @collection})
      dom.append(transactionGroupView.render().el)
    )

  render: =>
    $(@el).html(@template)
    @renderNew()
    @renderExisting()
    @
