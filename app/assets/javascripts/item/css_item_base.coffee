# CSSアイテム
# @extend ItemBase
class CssItemBase extends ItemBase
  # オプションメニュー
  btnEntryForm : $("#btn-entryForm", sidebarWrapper)
  configBoxLi : $("div.configBox > div.forms", sidebarWrapper)
  btnGradientStep : $("#btn-gradient-step")
  btnBgColor : $("#btn-bg-color1,#btn-bg-color2,#btn-bg-color3,#btn-bg-color4,#btn-bg-color5,#btn-border-color,#btn-font-color")
  btnShadowColor : $("#btn-shadow-color,#btn-shadowinset-color,#btn-text-shadow1-color,#btn-text-shadow2-color");

  # CSSのルートのIDを取得
  getCssRootElementId: ->
    return "css-" + @id

  # オプションメニューを作成
  # @abstract
  setupOptionMenu: ->
