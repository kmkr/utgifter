# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  $('#transactions form input[type=submit]').live('click', (evt) ->
    form = $(this).closest('form')

    data =
      transaction:
        time: form.find('.time').val()
        amount: form.find('.amount').val()
        description: form.find('.description').val()
        transaction_group_id: form.find('.transaction_groups').find(':selected').val()

    $.post('/transactions', data, =>
      form.fadeTo('slow', '0.5')
      $(this).attr('disabled', 'disabled')
    )
    
    evt.preventDefault()
  )
)
