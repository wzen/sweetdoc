class Parts < ActiveRecord::Base
  def self.button_css_default
    Parts.find_by(type_cd: Constant::DbTable::Parts::TypeCd::CSS_DEFAULT)
  end
end
