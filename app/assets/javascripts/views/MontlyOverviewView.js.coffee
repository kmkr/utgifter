class utgifter.views.MonthlyOverviewView extends Backbone.View
  
  initialize: (options) ->
    _.extend(@, new utgifter.mixins.YearFilterButtons())
    @year = options.year

  template: JST['overview/monthly']
  render: ->
    $(@el).append(@template)
    @renderYearFilterButtons(@collection)
    @

  renderGraph: (transactions = @collection.byYear(@year)) ->
    renderChartTo = document.getElementById("chartContainer")
    result = utgifter.charts.dataGenerator(transactions, { frequency: "monthly", noNegativeValues: true })
    @chart = new utgifter.charts.column.ColumnChart(result.categories, result.series, renderChartTo)

  path: (year) ->
    "#overview/#{year}/monthly"
  leave: ->
    @chart.destroy()
