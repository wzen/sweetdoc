class ProjectGalleryMap < ActiveRecord::Base
  belongs_to :project
  belongs_to :gallery
end
