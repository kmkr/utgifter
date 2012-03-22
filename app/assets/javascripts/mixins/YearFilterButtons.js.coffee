class utgifter.mixins.YearFilterButtons

  renderYearFilterButtons: (transactions) ->
    years = @collection.getYears()
    for year in years
      id = "overview_#{year}"
      controls = $(@el).find(".controls")
      button = $("<a class='btn btn-primary' href='#{@path(year)}' id='#{id}'>#{year}</a>")
      button.addClass("active") if year == @year
      controls.append(button)
