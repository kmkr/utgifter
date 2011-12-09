@module "utgifter", ->
  @module "charts", ->
    @module "column", ->
      class @ColumnChart
        constructor: (categories, series, renderTo) ->
          chart = new Highcharts.Chart(
            chart:
              renderTo: renderTo
              defaultSeriesType: 'column'
            credits:
              enabled: false
            title:
              text: 'Inntekt vs utgift'
            xAxis:
              categories: categories
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
            series: series
          )
