@module "utgifter", ->
  @module "charts", ->
    @module "column", ->
      class @ColumnChart
        constructor: (categories, series, renderTo) ->
          chart = new Highcharts.Chart(
            chart:
              renderTo: renderTo
              defaultSeriesType: 'column'
            title:
              text: 'Inntekt vs utgift'
            xAxis:
              categories: categories
            yAxis:
              title:
                text: 'Beløp'
            legend:
              layout: 'vertical'
              backgroundColor: '#FFFFFF'
              align: 'left'
              verticalAlign: 'top'
              x: 100
              y: 70
              floating: true
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
