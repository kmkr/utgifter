class utgifter.views.TransactionCandidateView extends Backbone.View
  template: JST['transaction_batches/show']

  views: []

  initialize: (args) ->
    _.extend(@, new utgifter.mixins.FormErrorHandling())

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
    $(@el).find('.spinner').show()
    time = $(@el).find("input[name=time]").val()
    amount = $(@el).find("input[name=amount]").val()
    description = $(@el).find("input[name=description]").val()

    @model.set({time: time, amount: amount, description: description})
    @collection.add(@model)
    console.log("saving...")
    @model.save({}, {
      success: =>
        console.log("saved! %o", @)
        @removeSelf()
      error: ->
        console.log("error ... %o", arguments)
    })

  removeSelf: =>
    $(@el).hide('fade', => $(@el).remove())

  render: ->
    $(@el).html(@template(@model.attributes))
    el = @el
    $(@el).find('input[type=date]').dateinput({lang: 'no', format: 'yyyy-mm-dd', firstDay: 1, change: ->
      $(el).find('input[name=time]').val(@getValue().toUTCString())
    })
    @setupForm()
    @

  leave: ->
    @leaveForm()
