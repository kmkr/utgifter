class window.utgifter.views.TransactionView extends Backbone.View
  template: JST['transactions/show']

  events: ->
    "ajax:success form":                            "highlightForm"
    "ajax:success form a.delete-transaction":       "removeFromList"

  render: ->
    $(@el).html(@template(@model.attributes))
    @

  highlightForm: (evt) ->
    console.log("TODO: oppdater collection!")
    console.log("TODO: alle som bruker transactions må oppdateres!")
    form = $(evt.target)
    $(form).effect('highlight')

  removeFromList: (evt) ->
    console.log("TODO: oppdater collection!")
    console.log("TODO: alle som bruker transactions må oppdateres!")
    form = $(evt.target).closest('form')
    form.hide('slow', -> $(@).remove())
