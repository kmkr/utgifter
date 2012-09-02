class utgifter.views.ColumnChart extends Backbone.View
  views: []
  render: ->

  initialize: (categories, series, renderTo) ->
    @categories = categories
    @series = series
    @render()

  updateTranses: (evt) =>
    category = evt.point.category
    month = category.replace(/\d{4}\//, "")
    monthNumber = utgifter.charts.helpers.months.indexOf(month) + 1
    
    transactions = new utgifter.collections.TransactionCollection(evt.currentTarget.options.transactionsInSerie).byMonth(monthNumber)

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

  render: ->
    @chart.destroy() if @chart

    @chart = new Highcharts.Chart(
      chart:
        renderTo: 'chartContainer'
        defaultSeriesType: 'column'
      credits:
        enabled: false
      title:
        text: 'Inntekt vs utgift'
      xAxis:
        categories: @categories
      yAxis:
        title:
          text: 'Beløp'
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
      tooltip:
        formatter: ->
          "#{@x}: #{@y} kr"
      plotOptions:
        column:
          pointPadding: 0.2
          borderWidth: 0
          events:
            click: @updateTranses
      series: @series
    )

  leave: ->
    @chart.destroy()
