@module "utgifter", ->
  @module "charts", ->
    @module "bar", ->
      class @BarChart
        @chart = null

        updateTranses: ->
          transactions = @options.transactionsForGroup

          desc = ''
          for transaction in transactions
            date = new Date(transaction.time)
            desc += "<b>(#{date.getFullYear()}-#{date.getMonth()}-#{date.getDate()})</b>"
            desc += transaction.description
            desc += "<b>(#{transaction.amount})</b>"
            desc += "<br />"

          $('#transaction-overview').html(desc)

        constructor: (categories, series) ->
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
              categories: categories
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
            series: series
          )

        update: (categories, series) ->
          @chart.xAxis[0].setCategories(categories, false)

          $.each(series, (i) =>
            @chart.series[i].setData(series[i].data, false)
          )

          @chart.redraw()

