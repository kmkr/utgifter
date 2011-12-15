class utgifter.models.Transaction extends Backbone.Model
  prettyTime: ->
    time = new Date(@get('time'))
    year = time.getFullYear()
    month = time.getMonth() + 1
    month = "0" + month if month < 10
    date = time.getDate()
    date = "0" + date if date < 10
    "#{year}-#{month}-#{date}"

  # når tid kommer fra server:
  # attributes.time kommer som UTZ. konverter til GMT
  # problemet er at man ikke bruker "fetch" på collection til å hente initielt
  parse: (attributes) ->
    attributes

  # før tid sendes til server:
  #new Date(Date.parse(time) + (new Date().getTimezoneOffset() * 60 * 1000))
