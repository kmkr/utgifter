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
      use_as_skiplist = form.find("input[name=use_as_skiplist]").is(':checked')
      @model.save({ title: title, regex: regex, use_as_skiplist: use_as_skiplist },
        { success: -> form.effect('highlight') }
      )

  deleteEntry: (evt) =>
    @model.destroy()
    evt.preventDefault()

  removeFromList: (model) =>
    $(@el).hide('slow', -> $(@).remove())

  leave: ->
    @model.unbind('destroy', @removeFromList)
