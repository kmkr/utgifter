class window.utgifter.views.TransactionGroupsView extends Backbone.View
  template: JST['transaction_groups/index']

  renderNew: (dom) ->
    dom.html(new utgifter.views.NewTransactionGroupView().render().el)

  renderExisting: (dom) ->
    @collection.each((transactionGroup) ->
      transactionGroupView = new utgifter.views.TransactionGroupView({model: transactionGroup})
      dom.append(transactionGroupView.render().el)
    )

  render: ->
    $(@el).html(@template)
    @renderNew($(@el).find(".add-transaction-group"))
    @renderExisting($(@el).find(".transaction-groups"))
    @
