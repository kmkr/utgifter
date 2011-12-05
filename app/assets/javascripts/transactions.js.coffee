# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  chartSettings =
    chart:
      renderTo: 'chartContainer'
      defaultSeriesType: 'bar'
    title:
      text: 'Transaksjoner'
    xAxis:
      categories: ['Januar', 'Februar'] # her skal hver måned som det finnes transaksjonsdata for være
      title:
        text: null
    yAxis:
      min: 0
      title:
        text: 'Kroner'
        align: 'high'
    tooltip:
      formatter: ->
        this.series.name + ' ' + this.y + ' something'
    plotOptions:
      bar:
        dataLabels:
          enabled: true
    legend:
      layout: 'vertical'
      align: 'right'
      verticalAlign: 'top'
      x: -100
      y: 100
      floating: true
      borderWidth: 1
      backgroundColor: '#FFFFFF'
      shadow: true
            
    series: [ # for hver transaksjonsgruppe skal sum for hver måned listes opp
      {
        name: 'Mat'
      data: [50, 60]
      },
        {
          name: 'Fun'
          data: [40, 90]
        }
    ]

  chart = new Highcharts.Chart(chartSettings)
)
