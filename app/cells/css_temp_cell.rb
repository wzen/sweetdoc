class CssTempCell < Cell::Rails

  def button
    @css = Parts.button_css_default
    render
  end

end
