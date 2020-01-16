$ ->
  $('#video_url').on 'change paste', (e) ->
    video_title = $('#video_title')
    if video_title.val().length == 0
      $.ajax '/videos/youtube_title?url=' + $(this).val(),
        type: 'get'
        success: (response)->
          video_title.val(response.result)
