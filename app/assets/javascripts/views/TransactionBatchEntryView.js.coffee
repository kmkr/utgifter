class utgifter.views.TransactionBatchEntryView extends Backbone.View
  template: JST['transaction_batches/show']

  initialize: (args) ->
    @model.bind('add', @removeSelf)
    @errors = args.errors || []

  events:
    "click input[type=submit]"  : 'validateAndCreate'
    "keypress input"            : 'validateForm'
    "change input"              : 'validateForm'

  validate: =>
    inputs = $(@el).find('form[data-validate=true]')
    isValid = true
    for input in inputs
      isValid = false if validateField(input)

    isValid

  validateForm: ->
    form = $(@el).find('form')
    isValid = form.data('validator').checkValidity()
    if isValid
      @removeTooltips(form)

  removeTooltips: (form) ->
    for field in form.find('input')
      field = $(field)
      tooltip = field.data('tooltip')
      if tooltip
        tooltip.hide()
        field.unbind('focus')

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

  getTextFromError: (error) ->
    switch error
      when "amount" then "Greide ikke tolke det opprinnelige beløpet. Skriv et beløp manuelt inn, eller slett raden."
      when "description" then "Greide ikke tolke den opprinnelige beskrivelsen. Skriv beskrivelse manuelt inn, eller slett raden."
      when "time" then "Greide ikke tolke det opprinnelige tidspunktet. Fyll tidspunkt ut, eller slett raden."

  highlightErrors: ->
    for error in @errors
      match = error.match(/duplicate_transaction_(\d+)/)
      if match
        transaction = @collection.find((transaction) -> transaction.get('id') == parseInt(match[1], 10))
        errors = $(@el).find(".errors")
        errors.append("Mulig duplikat av #{transaction.get('id')}")
        element = $(@el).find('form')
        element.attr('title', """
        Mulig duplikat av transaksjonen med:
          <ul>
            <li>Beløp '#{transaction.get('amount')}'</li>
            <li>Beskrivelse '#{transaction.get('description')}'</li>
            <li>Tidspunkt '#{transaction.prettyTime()}' </li>
            <li>Opprettet '#{transaction.get('created_at')}'</li>
          </ul>
        """)
      else
        element = $(@el).find("input[name='#{error}']")
        element.attr('title', @getTextFromError(error))

      element.tooltip(
        offset: [-2, 10]
        effect: "fade"
        opacity: 0.8
      )

  render: ->
    $(@el).html(@template(@model.attributes))
    $(@el).find('input[type=date]').dateinput({lang: 'no', format: 'yyyy-mm-dd', firstDay: 1})
    fields = $(@el).find('form').validator({ opacity: 0.8, lang: 'no', position: 'bottom center' })
    @highlightErrors()
    @
