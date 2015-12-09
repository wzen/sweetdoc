class PreloadItemImage extends ItemBase

  @actionProperties =
  {
    modifiables: {
      imagePath: {
        name: "Select image"
        type: 'select_file'
        ja: {
          name: "画像を選択"
        }
      }
    }
  }

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super()
    @imagePath = null
    @isKeepAspect = false
    @scale = {w:1.0, h:1.0}

  # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: ->
    contents = """

        """
    return Common.wrapCreateItemElement(@, contents)

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  reDraw: (show = true)->
    super(show)

    if @imagePath?
      # imgタグを作成or更新
    else
      # imgパス選択フィールド表示
