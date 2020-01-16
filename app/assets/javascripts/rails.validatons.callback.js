ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
  callback();
  if (element.data('valid') !== false) {
    element.parent().find('.message').hide().show('slide', {direction: "left", easing: "easeOutBounce"}, 500);
  }
}

ClientSideValidations.callbacks.element.pass = function(element, callback) {
  element.parent().find('.message').hide('slide', {direction: "left"}, 500, callback);
}
