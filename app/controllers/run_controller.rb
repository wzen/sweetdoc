class RunController < ApplicationController
  def index
    # リクエストサイズ表示
    p "content_length: #{request.content_length}"

    # Constantの設定
    init_const

    @is_runwindow_reload = !request.post?
    unless @is_runwindow_reload
      # PageValueの書き込み
      @instance_pagevalues, @event_pagevalues = Run.init_pagevalue(params)
    end
  end
end
