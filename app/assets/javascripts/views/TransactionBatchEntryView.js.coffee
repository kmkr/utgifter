class window.utgifter.views.TransactionBatchEntryView extends Backbone.View
  template: JST['transaction_batches/show']

  initialize: ->
    @model.bind('add', @removeSelf)

  events:
    "click input[type=submit]" : 'createTransaction'

  createTransaction: (evt) =>
    evt.preventDefault()

    time = $(@el).find("input[name=time]").val()
    amount = $(@el).find("input[name=amount]").val()
    description = $(@el).find("input[name=description]").val()

    @model.set({time: time, amount: amount, description: description})
    @collection.add(@model)
    @model.save()

  removeSelf: =>
    $(@el).hide('fade', -> $(@).remove())

  render: ->
    $(@el).html(@template(@model.attributes))
    @
