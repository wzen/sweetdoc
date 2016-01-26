class ModalViewController < ApplicationController
  def show
    type = params['type']
    @parent_url = params['parentUrl']
    @result_success = true
    @modalHtml = render_to_string :action => type, :layout => false
  end
end
