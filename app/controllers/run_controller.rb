class RunController < ApplicationController
  def index
    # Constantの設定
    init_const

    # PageValueの書き込み
    @timeline_page_values = Run.init_timeline_pagevalue(params)
  end
end
