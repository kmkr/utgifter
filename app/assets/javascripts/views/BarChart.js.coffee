class utgifter.views.BarChart extends Backbone.View
  views: []

  initialize: (categories, series) ->
    @categories = categories
    @series = series

  updateTranses: (evt) =>
    transactions = evt.target.options.transactionsInSerie
    doWork = =>
      $('#transaction-overview').html(JST['transactions/table']())
      tbody = $('tbody', $('#transaction-overview'))
      $.each(transactions, (i, transaction) =>
        view = new utgifter.views.TransactionView({model: transaction})
        @views.push(view)
        tbody.append(view.render().el)
      )
    # async
    setTimeout(doWork, 1)

  render: =>
    @chart = new Highcharts.Chart(
      chart:
        height: 800
        renderTo: 'chartContainer'
        defaultSeriesType: 'bar'
      credits:
        enabled: false
      title:
        text: 'Transaksjoner'
      xAxis:
        categories: @categories
        title:
          text: null
      yAxis:
        title:
          text: 'Kroner'
          align: 'high'
      tooltip:
        formatter: ->
          @series.name + ' (' + @y + ' kr)'
      plotOptions:
        bar:
          events:
            mouseOver: @updateTranses
          dataLabels:
            enabled: true
      legend:
        layout: 'vertical'
        align: 'right'
        verticalAlign: 'top'
        x: 0
        y: 0
        floating: true
        borderWidth: 1
        backgroundColor: '#FFFFFF'
        shadow: true
      series: @series
    )

  leave: ->
    @chart?.destroy?()
