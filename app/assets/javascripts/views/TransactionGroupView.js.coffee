class window.utgifter.views.TransactionGroupView extends Backbone.View
  template: JST['transaction_groups/show']

  initialize: ->
    @model.bind('destroy', @removeFromList)

  events: ->
    "click input[type=submit]"          : "updateEntry"
    "click a.delete-transaction-group"  : "deleteEntry"

  render: ->
    $(@el).html(@template(@model.attributes))
    @

  updateEntry: (evt) =>
    form = $(@el).closest("form")
    title = form.find("input[name=title]").val()
    regex = form.find("input[name=regex]").val()
    @model.save({ title: title, regex: regex }, { success: ->
      console.log("TODO: alle som bruker transactionsgroup må oppdateres!")
      form = $(evt.target)
      $(form).effect('highlight')
    })
    evt.preventDefault()

  deleteEntry: (evt) =>
    @model.destroy()
    evt.preventDefault()

  removeFromList: (model) =>
    $(@el).hide('slow', -> $(@).remove())
