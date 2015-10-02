# 閲覧を実行する
run = ->
  # プレビュー停止
  WorktableCommon.stopAllEventPreview( ->

    # イベント存在チェック
    h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
    if h? && Object.keys(h).length > 0
      # Runのキャッシュを削除
      LocalStorage.clearRun()

      # 実行用の新規タブを表示
      target = "_runwindow"
      window.open("about:blank", target)
      document.run_form.target = target
      # データ保存処理
      ServerStorage.save( ->
        # submit詰まり防止のため少し遅延させる
        setTimeout( ->
          document.run_form.submit()
        , 200)
      )

    else
      # イベントが存在しない場合は表示しない
      Message.showWarn('No event')
  )
