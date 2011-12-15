# Remember that "@model" is the new transaction that is not yet saved
# "@duplicate" is the previously saved model
class utgifter.views.DuplicateTransactionView extends Backbone.View
  template: JST["transaction_batches/duplicate"]

  initialize: (args) ->
    @duplicate = args.duplicate

  events: ->
    "click a.update-description"        : "updateDescription"

  updateDescription: (evt) ->
    evt.preventDefault()
    @duplicate.save({description: @model.get('description')})

  render: ->
    $(@el).html(@template({model: @model, duplicate: @duplicate}))
    @
