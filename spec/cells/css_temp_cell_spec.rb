require 'spec_helper'

describe CssTempCell, type: :cell do

  context 'cell rendering' do
    context 'rendering button' do
      subject { render_cell(:css_temp, :button) }

      it { is_expected.to include 'CssTemp#button' }
      it { is_expected.to include 'Find me in app/cells/css_temp/button.html' }
    end
  end

end
