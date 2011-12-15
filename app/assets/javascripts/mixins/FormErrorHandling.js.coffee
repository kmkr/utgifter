# assumes:
# @form
# @collection
# @model
class utgifter.mixins.FormErrorHandling

  validateForm: ->
    isValid = @form.data('validator').checkValidity()
    if isValid
      @removeTooltips()

    isValid

  setupForm: (form) ->
    @form = form
    @form.validator({ opacity: 0.8, lang: 'no', position: 'bottom center' })

    if @model.isPossibleDuplicate()
      @doSomethingWithDuplicate()

    for error in @model.get('errors')
      element = @form.find("input[name='#{error}']")
      if (element)
        element.attr('title', @getTextFromError(error))
        element.tooltip(
          offset: [-2, 10]
          effect: "fade"
          opacity: 0.8
        )

  doSomethingWithDuplicate: ->
    # legg til duplikater i @el
    console.log(@model.possibleDuplicates())
    possibleDuplicateTransactions = @collection.filter((transaction) => _.include(@model.possibleDuplicates(), transaction.get('id')))
    console.log("fant %o duplikater", possibleDuplicateTransactions)
    for possibleDuplicate in possibleDuplicateTransactions
      $(@el).append("""
        Mulig duplikat av transaksjonen med:
          <ul>
            <li>Beløp '#{possibleDuplicate.get('amount')}'</li>
            <li>Beskrivelse '#{possibleDuplicate.get('description')}'</li>
            <li>Tidspunkt '#{possibleDuplicate.prettyTime()}' </li>
            <li>Opprettet '#{possibleDuplicate.get('created_at')}'</li>
          </ul>
        """)

  getTextFromError: (error) ->
    switch error
      when "amount" then "Greide ikke tolke det opprinnelige beløpet. Skriv et beløp manuelt inn, eller slett raden."
      when "description" then "Greide ikke tolke den opprinnelige beskrivelsen. Skriv beskrivelse manuelt inn, eller slett raden."
      when "time" then "Greide ikke tolke det opprinnelige tidspunktet. Fyll tidspunkt ut, eller slett raden."


  # Destroys the error handling (not the DOM itself)
  leaveForm: ->
    @removeTooltips()
    @form.data('validator').destroy()

  removeTooltips: ->
    for field in @form.find('input')
      field = $(field)
      tooltip = field.data('tooltip')
      if tooltip
        tooltip.hide()
        field.unbind('focus')
