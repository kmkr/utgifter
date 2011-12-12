class utgifter.models.Transaction extends Backbone.Model
  prettyTime: ->
    time = new Date(@get('time'))
    year = time.getFullYear()
    month = time.getMonth() + 1
    month = "0" + month if month < 10
    date = time.getDate()
    date = "0" + date if date < 10
    "#{year}-#{month}-#{date}"
