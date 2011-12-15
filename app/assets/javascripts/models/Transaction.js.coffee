class utgifter.models.Transaction extends Backbone.Model
  prettyTime: ->
    time = new Date(@get('time'))
    year = time.getFullYear()
    month = time.getMonth() + 1
    month = "0" + month if month < 10
    date = time.getDate()
    date = "0" + date if date < 10
    "#{year}-#{month}-#{date}"

  isPossibleDuplicate: ->
    _.any(@get('errors'), (error) -> error.match(/duplicate_transaction_(\d+)/))

  possibleDuplicates: ->
    duplicates = []
    for error in @get('errors')
      if match = error.match(/duplicate_transaction_(\d+)/)
        duplicates.push(parseInt(match[1], 10))

    duplicates

