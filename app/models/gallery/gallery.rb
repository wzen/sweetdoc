require 'xmlrpc/client'
require 'project/project'
require 'project/project_gallery_map'
require 'project/user_project_map'
require 'gallery/gallery_tag'
require 'gallery/gallery_tag_map'
require 'gallery/gallery_general_pagevalue'
require 'gallery/gallery_general_pagevalue_paging'
require 'gallery/gallery_instance_pagevalue'
require 'gallery/gallery_instance_pagevalue_paging'
require 'gallery/gallery_event_pagevalue'
require 'gallery/gallery_event_pagevalue_paging'
require 'gallery/gallery_view_statistic'
require 'gallery/gallery_bookmark'
require 'gallery/gallery_bookmark_statistic'
require 'item/item_image'
require 'pagevalue/page_value_state'
require 'item/preload_item'

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
