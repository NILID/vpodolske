$ ->

  $('#top-link-block').on 'click', ->
    $("html, body").animate({scrollTop: 0}, "slow")

  $('.select2-token').select2
    multiple: true
    minimumInputLength: 2
    theme: 'bootstrap'
    width: 'auto'
    allowClear: true
    ajax:
      url: $('.select2-token').data('endpoint')
      dataType: 'json'
      delay: 250
      data: (params) ->
        {
          q: params.term
          page: params.page
        }

      processResults: (data) ->
        {
          results: $.map(data, (item) ->
            {
              text: item.title
              id: item.id
            }
        )}

  $('#flash').delay(4500).fadeOut('slow')

  $('.dtm-event-startdate').datetimepicker
    format: 'DD/MM/YYYY'

  $('.dtm-event-finishdate').datetimepicker
    format: 'DD/MM/YYYY'
    useCurrent: false

  $('.dtm-event-time').datetimepicker
    stepping: 10
    format: 'HH:mm'

  $('.dtm-event-startdate').on 'dp.change', (e) ->
    $('.dtm-event-finishdate').data('DateTimePicker').minDate e.date
  $('.dtm-event-finishdate').on 'dp.change', (e) ->
    $('.dtm-event-startdate').data('DateTimePicker').maxDate e.date

  if ($('.news .article').length > 1)
    current_item = window.location.hash.substr(1)
    if current_item
      $('#' + current_item).addClass('info')

  $('#diff-container').twentytwenty
    before_label: 'До'
    after_label: 'После'

  bLazy = new Blazy(selector: '.b-lazy')