class utgifter.mixins.YearFilterButtons

  renderYearFilterButtons: (transactions) ->
    years = @collection.getYears()
    for year in years
      id = "overview_#{year}"
      button = "<a href='#{@path(year)}' id='#{id}'>#{year}</a>"
      controls = $(@el).find(".controls")
      controls.append(button)
