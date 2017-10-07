/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class ColorPickerUtil {

  // カラーピッカーの設定
  // @param [Object] element HTML要素
  // @param [Color] colorValue 変更色
  // @param [Function] onChange 変更時に呼ばれるメソッド
  static initColorPicker(element, colorValue, onChange) {
    let setColor = null;
    if(typeof colorValue === 'string') {
      if(colorValue.indexOf('rgb') === 0) {
        colorValue = Common.colorFormatChangeRgbToHex(colorValue);
        setColor = colorValue;
      } else {
        setColor = colorValue.replace('#', '');
        setColor = `#${setColor}`;
      }
    } else {
      setColor = `rgb(${colorValue.r}, ${colorValue.g}, ${colorValue.b})`;
    }
    element.css("backgroundColor", setColor);
    element.ColorPicker({});
    element.ColorPickerSetColor(colorValue);
    element.ColorPickerResetOnChange(function(a, b, d, e) {
      element.css("backgroundColor", `#${b}`);
      if(onChange != null) {
        return onChange(a, b, d, e);
      }
    });
    element.unbind();
    return element.mousedown(function(e) {
      e.stopPropagation();
      WorktableCommon.clearAllItemStyle();
      element.ColorPickerHide();
      return element.ColorPickerShow();
    });
  }


  //カラーピッカー値の初期化(アイテムのコンテキスト表示時に設定)
  static initColorPickerValue() {
    return $('.colorPicker', sidebarWrapper).each(function() {
      const id = $(this).attr('id');
      const color = $(`.${id}`, cssCode).html();
      $(this).css('backgroundColor', `#${color}`);
      const inputEmt = sidebarWrapper.find(`#${id}-input`);
      return inputEmt.attr('value', color);
    });
  }
}
