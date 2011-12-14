class utgifter.views.ColumnChart extends Backbone.View
  render: ->

  initialize: (categories, series, renderTo) ->
    @categories = categories
    @series = series
    @render()

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
      series: @series
    )

  leave: ->
    @chart.destroy()
