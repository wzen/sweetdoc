// Generated by CoffeeScript 1.9.2
var initColorPicker, initColorPickerValue;

initColorPicker = function(element, colorValue, onChange) {
  element.css("backgroundColor", "#" + colorValue);
  element.ColorPicker({});
  element.ColorPickerSetColor(colorValue);
  element.ColorPickerResetOnChange(function(a, b, d) {
    element.css("backgroundColor", "#" + b);
    if (onChange != null) {
      return onChange(a, b, d);
    }
  });
  element.unbind();
  return element.mousedown(function(e) {
    e.stopPropagation();
    clearAllItemStyle();
    element.ColorPickerHide();
    return element.ColorPickerShow();
  });
};

initColorPickerValue = function() {
  return $('.colorPicker', sidebarWrapper).each(function() {
    var color, id, inputEmt;
    id = $(this).attr('id');
    color = $('.' + id, cssCode).html();
    $(this).css('backgroundColor', '#' + color);
    inputEmt = sidebarWrapper.find('#' + id + '-input');
    return inputEmt.attr('value', color);
  });
};

//# sourceMappingURL=colorpicker.js.map