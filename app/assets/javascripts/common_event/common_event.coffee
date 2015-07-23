# 共通イベント
class CommonEvent extends Extend
  @include EventListener
  @include CommonEventListener

# 背景イベント
class BackgroundEvent extends CommonEvent

# 画面表示イベント
class ScreenEvent extends CommonEvent