class Project < ActiveRecord::Base
  has_many :project_gallery_maps
  has_many :user_project_maps
end
