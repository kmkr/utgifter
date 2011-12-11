class window.utgifter.views.TransactionView extends Backbone.View
  template: JST['transactions/show']

  initialize: ->
    @model.bind("change", @highlightForm)

  events: ->
    "click input[type=submit]"                : "updateTransaction"
    "click form a.delete-transaction"         : "deleteTransaction"

  render: ->
    $(@el).html(@template(@model.attributes))
    @

  highlightForm: =>
    $(@el).effect('highlight')

  updateTransaction: (evt) =>
    time = $(@el).find("input[name=time]").val()
    amount = $(@el).find("input[name=amount]").val()
    description = $(@el).find("input[name=description]").val()
    @model.save({time: time, amount: amount, description: description})
    evt.preventDefault()

  deleteTransaction: (evt) =>
    evt.preventDefault()
    form = $(@el).find('form')
    @model.destroy({ success: ->
      form.hide('slow', -> $(@).remove())
    })
    
