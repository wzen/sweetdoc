class ItemGallery
  def self.save_state(
    user_id,
    user_coding_id,
    tags,
    title,
    caption
  )
    begin
      ActiveRecord::Base.transaction do

      end
    rescue => e
    end
  end
end