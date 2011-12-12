class utgifter.views.TransactionsView extends Backbone.View
  template: JST['transactions/index']

  render: ->
    $(@el).html(@template)
    $(@el).append(JST['transactions/table'])
    transactionsContainer = $(@el).find(".transactions")
    @collection.each((transaction) ->
      transactionView = new utgifter.views.TransactionView({model: transaction, collection: @collection})
      transactionsContainer.append(transactionView.render().el)
    )

    @table = $(@el).find('table').dataTable({
      sPaginationType: 'full_numbers',
      iDisplayLength: 25,
      oLanguage:
        oPaginate:
          sFirst: '&laquo;'
          sLast: '&raquo;'
          sNext: 'Neste'
          sPrevious: 'Forrige'
        sEmptyTable: 'Ingen transaksjoner'
        sInfo: 'Viser rad _START_ til _END_ (Totalt _TOTAL_ rader)'
        sInfoEmpty: 'Ingen rader å vise'
        sInfoFiltered: ' - filtrerer fra _MAX_ rader'
        sLengthMenu: 'Vis _MENU_ samtidige rader'
        sLoadingRecords: 'Laster ...'
        sProcessing: 'Prosesserer'
        sSearch: 'Filtrer rader:'
        sZeroRecords: 'Ingen rader å vise'
    })
    @
