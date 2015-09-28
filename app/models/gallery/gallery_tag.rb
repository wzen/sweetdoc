class GalleryTag < ActiveRecord::Base
  has_many :gallery_tag_maps

  def self.get_popular_tags
    limit = 100
    take_num = 3

    ordered = self.order('weight DESC').limit(limit)
    get_row = []
    # ランダムに取得
    while get_row.length <= take_num
      random = Random.new
      r = random.rand(0..(limit - 1))
      unless get_row.include?(r)
        get_row << r
      end
    end
    tags = ordered.map do |o|
      if get_row.include?(o.id)
        return o.name
      end
    end

    return tags
  end
end
