class Project < ActiveRecord::Base
  has_many :project_gallery_maps
  has_many :user_pagevalues

  def self.create(title, screen_width, screen_height)
    begin
      p = Project.new({title: title, screen_width: screen_width, screen_height: screen_height})
      p.save!
      return I18n.t('message.database.item_state.save.success'), p.id
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error'), null
    end
  end
end
