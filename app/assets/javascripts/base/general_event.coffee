# 共通イベント
class GeneralEvent extends Extend
  @include EventListener

# 背景変更イベント
class ChangeBackground extends GeneralEvent

# 画面ズームイベント
class ZoomView extends GeneralEvent
