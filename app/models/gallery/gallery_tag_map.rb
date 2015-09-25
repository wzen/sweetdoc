class GalleryTagMap < ActiveRecord::Base
  belongs_to :gallery
  belongs_to :gallery_tag
end
