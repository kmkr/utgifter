class utgifter.helpers.TransactionBatchErrorHighlightHelper

  constructor: (options) ->
    @collection = options.collection

  validateForm: (form) ->
    isValid = form.data('validator').checkValidity()
    if isValid
      @removeTooltips(form)

  setupForm: (form, errors) ->
    form.validator({ opacity: 0.8, lang: 'no', position: 'bottom center' })

    for error in errors
      match = error.match(/duplicate_transaction_(\d+)/)
      if match
        transaction = @collection.find((transaction) -> transaction.get('id') == parseInt(match[1], 10))
        form.attr('title', """
        Mulig duplikat av transaksjonen med:
          <ul>
            <li>Beløp '#{transaction.get('amount')}'</li>
            <li>Beskrivelse '#{transaction.get('description')}'</li>
            <li>Tidspunkt '#{transaction.prettyTime()}' </li>
            <li>Opprettet '#{transaction.get('created_at')}'</li>
          </ul>
        """)
        form.find('p.errors').html("Duplikat, gi mulighet til å oppdatere description")
        element = form
      else
        element = form.find("input[name='#{error}']")
        element.attr('title', @getTextFromError(error))

      element.tooltip(
        offset: [-2, 10]
        effect: "fade"
        opacity: 0.8
      )

  getTextFromError: (error) ->
    switch error
      when "amount" then "Greide ikke tolke det opprinnelige beløpet. Skriv et beløp manuelt inn, eller slett raden."
      when "description" then "Greide ikke tolke den opprinnelige beskrivelsen. Skriv beskrivelse manuelt inn, eller slett raden."
      when "time" then "Greide ikke tolke det opprinnelige tidspunktet. Fyll tidspunkt ut, eller slett raden."


  removeTooltips: (form) ->
    for field in form.find('input')
      field = $(field)
      tooltip = field.data('tooltip')
      if tooltip
        tooltip.hide()
        field.unbind('focus')
