class Gallery < ActiveRecord::Base
  belongs_to :user_project_map
  has_many :gallery_instance_pagevalue_pagings
  has_many :gallery_event_pagevalue_pagings
  has_many :gallery_tag_maps
  has_many :gallery_bookmarks
  has_many :gallery_view_statistics
  has_many :gallery_bookmark_statistics
  has_many :projects
  has_many :project_gallery_mapsX
  belongs_to :user, foreign_key: :created_user_id

  mount_uploader :thumbnail_img, GalleryThumbnailImageUploader
  validates :thumbnail_img,
            file_size: {
                maximum: (Const::THUMBNAIL_FILESIZE_MAX_KB * 0.001).megabytes.to_i
            }
end
