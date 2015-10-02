class UserProjectMap < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :project_gallery_maps
end
