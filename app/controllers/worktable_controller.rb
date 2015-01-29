require 'const'

class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    @common_action_events = CommonActionEvent.get_commonevents_initworktable
  end


end
