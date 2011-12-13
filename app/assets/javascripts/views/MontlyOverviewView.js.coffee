class utgifter.views.MonthlyOverviewView extends Backbone.View
  
  initialize: (options) ->
    _.extend(@, new utgifter.mixins.YearFilterButtons())
    @year = options.year

  template: JST['overview/monthly']

  render: ->
    $(@el).append(@template)
    @renderYearFilterButtons(@collection)
    @

  renderGraph: () ->
    @chart.destroy() if @chart
    renderChartTo = document.getElementById("chartContainer")
    result = utgifter.charts.dataGenerator({
      transactionGroups: [],
      transactions: @collection.byYear(@year),
      frequency: "monthly",
      useOnlyPositiveValues: true,
      text:
        nonGroupedExpensesText: 'Utgifter'
        nonGroupedIncomesText: 'Inntekter'
      })
    @chart = new utgifter.charts.column.ColumnChart(result.categories, result.series, renderChartTo)

  path: (year) ->
    "#overview/#{year}/monthly"

  leave: ->
    @chart.destroy()
