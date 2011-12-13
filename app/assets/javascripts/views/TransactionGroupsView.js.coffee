class utgifter.views.TransactionGroupsView extends Backbone.View
  template: JST['transaction_groups/index']

  views: []

  initialize: ->
    @collection.bind('add', @render)

  renderNew: ->
    dom = $(@el).find(".add-transaction-group")
    view = new utgifter.views.NewTransactionGroupView({collection: @collection})
    @views.push(view)
    dom.html(view.render().el)

  renderExisting: ->
    dom = $(@el).find(".transaction-groups")
    @collection.each((transactionGroup) =>
      transactionGroupView = new utgifter.views.TransactionGroupView({ model: transactionGroup, collection: @collection})
      @views.push(transactionGroupView)
      dom.append(transactionGroupView.render().el)
    )

  render: =>
    $(@el).html(@template)
    @renderNew()
    @renderExisting()
    @
