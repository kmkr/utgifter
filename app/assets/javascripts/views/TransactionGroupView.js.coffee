class utgifter.views.TransactionGroupView extends Backbone.View
  template: JST['transaction_groups/show']

  initialize: ->
    @model.bind('destroy', @removeFromList)

  events: ->
    "keypress input"                    : "updateOnEnter"
    "click a.delete-transaction-group"  : "deleteEntry"

  render: ->
    $(@el).html(@template(@model.attributes))
    @

  updateOnEnter: (evt) =>
    if evt.keyCode == 13
      form = $(@el).find("form")
      title = form.find("input[name=title]").val()
      regex = form.find("input[name=regex]").val()
      @model.save({ title: title, regex: regex }, { success: ->
        form.effect('highlight')
      })

  deleteEntry: (evt) =>
    @model.destroy()
    evt.preventDefault()

  removeFromList: (model) =>
    $(@el).hide('slow', -> $(@).remove())
