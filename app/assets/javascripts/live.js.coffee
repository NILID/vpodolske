$ ->
  if $('#slider-range').length

    myData = $('#slider-range').data('photos')
    myYear = $('#slider-range').data('years')
    handle_before = $( "#custom-handle-before" )
    handle_after = $( "#custom-handle-after" )

    $('#slider-range').slider
      range: true
      min: 0
      max: myData.length - 1
      step: 1
      slide: (event, ui) ->
        $.ajax '/live/get_photo?before_id=' + myData[ui.values[0]] + '&after_id=' + myData[ui.values[1]],
          type: 'get'
        handle_before.text(myYear[ui.values[0]])
        handle_after.text(myYear[ui.values[1]])
      create: ->
        $(this).slider 'values', 0, 0
        $(this).slider 'values', 1, myData.length - 1
        handle_before.text(myYear[0])
        handle_after.text(myYear[myYear.length - 1])
