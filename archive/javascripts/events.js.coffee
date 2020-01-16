$ ->
  addressPicker = new AddressPicker(
    map: id: '#map'
    places: language: 'ru')
  $('#address').typeahead null,
    displayKey: 'description'
    source: addressPicker.ttAdapter()
  $('#address').bind 'typeahead:selected', addressPicker.updateMap
  $('#address').bind 'typeahead:cursorchanged', addressPicker.updateMap

  addressPicker.bindDefaultTypeaheadEvent $('#address')
  $(addressPicker).on 'addresspicker:selected', (event, result) ->
    $('#lat_input').val result.lat()
    $('#lng_input').val result.lng()

