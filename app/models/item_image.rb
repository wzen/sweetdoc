class ItemImage < ActiveRecord::Base
  mount_uploader :file_path, ItemImageUploader
end
