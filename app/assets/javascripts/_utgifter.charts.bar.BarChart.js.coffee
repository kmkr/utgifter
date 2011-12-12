@module "utgifter", ->
  @module "charts", ->
    @module "bar", ->
      class @BarChart
        updateTranses: ->
          transactions = @options.transactionsInSerie
          $('#transaction-overview').html(JST['transactions/table']())
          tbody = $('tbody', $('#transaction-overview'))
          $.each(transactions, (i, transaction) =>
            tbody.append(new utgifter.views.TransactionView({model: transaction}).render().el)
          )

        constructor: (categories, series, renderTo) ->
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

        destroy: ->
          @chart.destroy()
