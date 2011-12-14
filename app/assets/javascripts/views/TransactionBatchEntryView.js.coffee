class utgifter.views.TransactionBatchEntryView extends Backbone.View
  template: JST['transaction_batches/show']


  initialize: (args) ->
    @model.bind('add', @removeSelf)
    @errors = args.errors || []
    @errorHighlightHelper = new utgifter.helpers.TransactionBatchErrorHighlightHelper({collection: @collection})

  events:
    "click input[type=submit]"            : 'validateAndCreate'
    "keypress input"                      : 'validateForm'
    "change input"                        : 'validateForm'
    "click a.delete-transaction-batch"    : 'delete'

  delete: (evt) =>
    evt.preventDefault()
    $(@el).hide('blind', =>$(@el).remove())

  validateForm: ->
    form = $(@el).find('form')
    @errorHighlightHelper.validateForm(form)

  validateAndCreate: (evt) =>
    evt.preventDefault()

    if @validateForm()
      @createTransaction()

  createTransaction: ->
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
    $(@el).find('input[type=date]').dateinput({lang: 'no', format: 'yyyy-mm-dd', firstDay: 1})
    @errorHighlightHelper.setupForm($(@el).find("form"), @errors)
    @

  leave: ->
    @model.unbind('add', @removeSelf)
