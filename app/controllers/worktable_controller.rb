class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const
  end

  def timeline_event_data
    # アクションイベントメソッド取得



    render action: 'worktable/sidebar_menu/timeline/json/event_data'
  end
end
