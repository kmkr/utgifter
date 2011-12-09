class window.utgifter.views.NewTransactionGroupView extends Backbone.View
  template: JST['transaction_groups/new']

  events: ->
    "ajax:success form"         : 'addModelToCollection'

  render: ->
    model = new utgifter.models.Transaction()
    $(@el).html(@template)
    @

  addModelToCollection: (evt) ->
    console.log("TODO: oppdater collection!")
    console.log("TODO: alle som bruker transactionsgroup må oppdateres!")
    form = $(evt.target)
    form.effect('highlight')
    form[0].reset()
