class utgifter.views.NewTransactionBatchView extends Backbone.View
  template: JST['transaction_batches/new']

  views: []

  events:
    "ajax:success #new_transaction_batch"     : "writeTransactions"
    "click #submit-all"                       : "submitAll"
    "change #transaction_batch_parser"        : "openBatchContentArea"

  openBatchContentArea: ->
    @openRelevantInfoBoxes()
    @$("#transaction_batch_content").show('blind')
    @$(".new_transaction_batch input[type=submit]").show()

  hideAdditionalInfoBoxes: ->
    @$('.additional-info-group').hide()

  openRelevantInfoBoxes: ->
    # hide all first
    @hideAdditionalInfoBoxes()

    idsToBeOpened = @$('#transaction_batch_parser option:selected').attr('data-view-type')
      
    unless idsToBeOpened
      return

    for idToBeOpened in idsToBeOpened.split(" ")
      @$("##{idToBeOpened}").closest('div').show()


  writeTransactions: (evt, response) =>
    @$('textarea').val('')
    for item in response
      transaction = new utgifter.models.Transaction(item)
      view = new utgifter.views.TransactionCandidateView({collection: @collection, model: transaction})
      @views.push(view)

      addTo = @getDomLocationToAdd(transaction)
      @$(addTo).append(view.render().el)
      @$(addTo).show()
      @$("#{addTo} form").last().show()


  getDomLocationToAdd: (transaction) ->
    duplicates = @getDuplicates(transaction)
    if duplicates?.length > 0
      transaction.duplicates = duplicates
      ".duplicated-transactions"
    else if transaction.get('errors')?.length > 0
      ".parse-error-transactions"
    else
      ".successfully-parsed-transactions"


  submitAll: (evt) ->
    evt.preventDefault()
    $('div.successfully-parsed-transactions input.submit-transaction').click()

  populateSelectYear: ->
    now = new Date().getFullYear()
    opt = $('<option>')
    @$('#select-year').append(opt.text(now))
    @$('#select-year').append(opt.clone().text(now - 1))

  render: ->
    $(@el).html(@template)
    view = new utgifter.views.LastAddedTransactionsView({collection: @collection})
    @views.push(view)
    @$(".last-transactions-wrapper").html(view.render().el)
    @populateSelectYear()
    @hideAdditionalInfoBoxes()
    @

  isCloseTo: (o1, o2) ->
    diff = Math.abs(o1.getTime() - o2.getTime())
    return diff < 432000000 # 5 days


  getDuplicates: (newTransaction) ->
    @collection.filter( (transaction) =>
      if newTransaction.get('amount') == transaction.get('amount')
        if @isCloseTo(new Date(newTransaction.get('time')), new Date(transaction.get('time')))
          return true
    )
