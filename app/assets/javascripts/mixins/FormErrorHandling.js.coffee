class utgifter.mixins.FormErrorHandling

  transactionsBound: []

  validateForm: ->
    form = $(@el).find('form')
    isValid = form.data('validator').checkValidity()
    if isValid
      @removeTooltips()

    isValid


  setupForm: () ->
    form = $(@el).find('form')
    form.validator({ opacity: 0.8, lang: 'no', position: 'bottom center' })

    if @model.duplicates
      @appendDuplicates()

    for error in @model.get('errors')
      element = form.find("input[name='#{error}']")
      if (element)
        element.attr('title', @getTextFromError(error))
        element.tooltip(
          offset: [-2, 10]
          effect: "fade"
          opacity: 0.8
        )


  appendDuplicates: ->
    for duplicate in @model.duplicates
      view = new utgifter.views.DuplicateTransactionView({model: @model, duplicate: duplicate})
      @views.push(view)

      # assuming that when the duplicate (the existing transaction) changes
      # description, its description is overwritten with the new transaction
      # candidate
      duplicate.bind("change:description", @hideSelf)
      @transactionsBound.push(duplicate)

      $(@el).find('.duplicates').append(view.render().el)


  getTextFromError: (error) ->
    switch error
      when "amount" then "Greide ikke tolke det opprinnelige beløpet. Skriv et beløp manuelt inn, eller slett raden."
      when "description" then "Greide ikke tolke den opprinnelige beskrivelsen. Skriv beskrivelse manuelt inn, eller slett raden."
      when "time" then "Greide ikke tolke det opprinnelige tidspunktet. Fyll tidspunkt ut, eller slett raden."


  leaveForm: ->
    @removeTooltips()
    for transaction in @transactionsBound
      transaction.unbind("change:description", @hideSelf)
    @transactionsBound.length = 0
    form = $(@el).find('form')

    # The form may already be destroyed, therefore do not assume form to have data
    form.data?('validator')?.destroy()


  removeTooltips: ->
    form = $(@el).find('form')
    for field in form.find('input')
      field = $(field)
      tooltip = field.data('tooltip')
      if tooltip
        tooltip.hide()
        field.unbind('focus')
