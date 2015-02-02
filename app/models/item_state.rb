require 'I18n'

class ItemState < ActiveRecord::Base
  belongs_to :user
end
