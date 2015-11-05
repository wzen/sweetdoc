# Buttonと同じ動作にする
class ItemXxx extends CssItemBase

  MyItem = @

  @CSSTEMPID = ''

  # クラス名と同じ
  @IDENTITY = "ItemXxx"

  if window.loadedItemId?
    @ITEM_ID = window.loadedItemId

  # アイテム作成時に設定される
  @elementId = ''


# Coffee Temp ---Start---
  init = ->

  @actionProperties: ->
    {
      defaultMethod: 'defaultClick'
      methods: {
        defaultClick: {
          actionType: Constant.ActionType.CLICK
          actionAnimationType: Constant.ActionAnimationType.CSS3_ANIMATION
          options: {
            id: 'defaultClick'
            name: 'Default click action'
            desc: "Click push action"
            ja: {
              name: '通常クリック'
              desc: 'デフォルトのボタンクリック'
            }
          }
        }

        changeColorScroll: {
          actionType: Constant.ActionType.SCROLL
          actionAnimationType: Constant.ActionAnimationType.JQUERY_ANIMATION
          scrollEnabledDirection: {
            top: true
            bottom: true
            left: false
            right: false
          }
          scrollForwardDirection: {
            top: false
            bottom: true
            left: false
            right: false
          }
          options: {
            id: 'changeColorScroll_Design'
            name: 'Changing color by click'
          }
        }
      }
    }

  variables = {

  }

  updateEventBefore = ->
    item = $("##{MyItem.elementId}")
    @getJQueryElement().css('opacity', 0)
    methodName = @getEventMethodName()
    if methodName == 'defaultClick'
      @getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration')


  updateEventAfter = ->

  draw = ->


  scrollEvent = ->

  clickEvent = ->

  cssAnimationElement = ->

  willChapter = ->

  didChapter = ->

# Coffee Temp ---End---

# 初期化
if window.itemInitFuncList? && !window.itemInitFuncList[ItemXxx.ITEM_ID]?
  window.itemInitFuncList[ItemXxx.ITEM_ID] = (option = {}) ->
    if window.isWorkTable && ItemXxx.jsLoaded?
      ItemXxx.jsLoaded(option)
    #JS読み込み完了
    if window.debug
      console.log('button loaded')

