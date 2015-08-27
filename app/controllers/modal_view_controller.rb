class ModalViewController < ApplicationController
  def show
    type = params['type']
    @modalHtml = render_to_string :action => type, :layout => false
  end
end
