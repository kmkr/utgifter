class utgifter.views.MonthlyOverviewView extends Backbone.View
  
  views: []

  initialize: (options) ->
    _.extend(@, new utgifter.mixins.YearFilterButtons())
    @year = options.year

  template: JST['overview/monthly']

  render: ->
    $(@el).append(@template)
    @renderYearFilterButtons(@collection)
    @

  renderGraph: () ->
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
    chart = new utgifter.views.ColumnChart(result.categories, result.series, renderChartTo)
    @views.push(chart)

  path: (year) ->
    "#overview/#{year}/monthly"
