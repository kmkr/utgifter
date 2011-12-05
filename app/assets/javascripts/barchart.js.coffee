@module "utgifter", ->
  @module "charts", ->
    @module "bar", ->
      class @BarChart
        constructor: (categories, series) ->
          new Highcharts.Chart(
            chart:
              renderTo: 'chartContainer'
              defaultSeriesType: 'bar'
            title:
              text: 'Transaksjoner'
            xAxis:
              categories: categories
              title:
                text: null
            yAxis:
              min: 0
              title:
                text: 'Kroner'
                align: 'high'
            tooltip:
              formatter: ->
                this.series.name + ' (' + this.y + ' kr)'
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
            series: series
          )
