class utgifter.views.TransactionBatchEntryView extends Backbone.View
  template: JST['transaction_batches/show']

  initialize: (args) ->
    @model.bind('add', @removeSelf)
    @errors = args.errors || []

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

  highlightErrors: ->
    for error in @errors
      $(@el).find("input[name='#{error}']").css('background-color', '#ffa7a7')

      match = error.match(/duplicate_transaction_(\d+)/)
      if match
        transaction = @collection.find((transaction) -> transaction.get('id') == parseInt(match[1], 10))
        $(@el).find(".errors").append("Duplikat av #{transaction.get('id')}")
        $(@el).find("input").css('background-color', '#ffa7a7')

  render: ->
    $(@el).html(@template(@model.attributes))
    @highlightErrors()
    @
