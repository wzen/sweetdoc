# Mix-in関数
moduleKeywords = ['extended', 'included']
class Extend
  # クラスメソッド拡張
  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value
    obj.extended?.apply(@) #callback
    this

  # インスタンスメソッド拡張
  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value
    obj.included?.apply(@) #callback
    this
