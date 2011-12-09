class window.utgifter.views.TransactionGroupView extends Backbone.View
  template: JST['transaction_groups/show']

  events: ->
    "ajax:success form":                            "highlightForm"
    "ajax:success form a.delete-transaction-group": "removeFromList"

  render: ->
    $(@el).html(@template(@model.attributes))
    @

  highlightForm: (evt) ->
    console.log("TODO: oppdater collection!")
    console.log("TODO: alle som bruker transactionsgroup må oppdateres!")
    form = $(evt.target)
    $(form).effect('highlight')

  removeFromList: (evt) ->
    console.log("TODO: oppdater collection!")
    console.log("TODO: alle som bruker transactionsgroup må oppdateres!")
    form = $(evt.target).closest('form')
    form.hide('slow', -> $(@).remove())
