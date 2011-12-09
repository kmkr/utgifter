class window.utgifter.views.TransactionBatchEntryView extends Backbone.View
  template: JST['transaction_batches/show']

  events:
    "ajax:success form.transaction"     : 'removeFromList'

  removeFromList: (evt) ->
    console.log("TODO: oppdater collection!")
    console.log("TODO: alle som bruker transactions må oppdateres!")
    form = $(evt.target)
    form.hide('fade', -> form.remove())

  render: ->
    $(@el).html(@template(@model.attributes))
    @
