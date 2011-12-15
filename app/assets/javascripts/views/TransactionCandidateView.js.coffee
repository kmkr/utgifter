class utgifter.views.TransactionCandidateView extends Backbone.View
  template: JST['transaction_batches/show']

  views: []

  initialize: (args) ->
    _.extend(@, new utgifter.mixins.FormErrorHandling())
    @model.bind('add', @hideSelf)

  events:
    "click input[type=submit]"            : 'validateAndCreate'
    "keypress input"                      : 'validate'
    # todo: change må lyttes på, men den klikker ved add så må gjøre noe lurt
    #"change input"                        : 'validateForm'
    "click a.delete-transaction-batch"    : 'delete'

  validate: (evt) =>
    evt.preventDefault()
    @validateForm

  delete: (evt) =>
    evt.preventDefault()
    $(@el).hide('blind')

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

  hideSelf: =>
    $(@el).effect('highlight', -> $(@).hide('fade'))

  render: ->
    $(@el).html(@template(@model.attributes))
    $(@el).find('input[type=date]').dateinput({lang: 'no', format: 'yyyy-mm-dd', firstDay: 1})
    @setupForm($(@el).find("form"))
    @

  leave: ->
    @leaveForm()
    @model.unbind('add', @hideSelf)
