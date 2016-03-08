class MotionCheckController < ApplicationController
  def index
    # リクエストサイズ表示
    p "content_length: #{request.content_length}"
    setup_run_data
  end

  def new_window
    setup_run_data
  end

  private
  def setup_run_data
    @is_runwindow_reload = !request.post?
    unless @is_runwindow_reload
      user_id = current_or_guest_user.id
      page_num = params['page_num']
      if page_num.blank?
        page_num = 1
      end
      general = params.require(Const::PageValueKey::G_PREFIX.to_sym)
      instance = params.require(Const::PageValueKey::INSTANCE_PREFIX.to_sym)
      event = params.require(Const::PageValueKey::E_SUB_ROOT.to_sym)
      footprint = params.fetch(Const::PageValueKey::F_PREFIX.to_sym, {})
      @pagevalues, @creator = Run.setup_data(user_id, general, instance, event, footprint, page_num)
      @is_sample_project = general[Const::Project::Key::IS_SAMPLE_PROJECT]
    end
  end

end
