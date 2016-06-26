class ProjectGalleryMap < ActiveRecord::Base
  belongs_to :user_project_map
  belongs_to :gallery
end
