class GalleryTag < ActiveRecord::Base
  has_many :gallery_tag_maps

  def self.get_popular_tags
    limit = 50
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

  def self.get_recommend_tags(got_popular_tags, recommend_source_word)
    if recommend_source_word == nil || recommend_source_word.length == 0
      return []
    end

    # はてなキーワードでカテゴリを調査
    client = XMLRPC::Client.new2("http://d.hatena.ne.jp/xmlrpc")
    result = client.call("hatena.setKeywordLink", {
                                                    body: recommend_source_word,
                                                    mode: 'lite',
                                                    score: 10
                                                })
    category = result['wordlist'].first['cname']
    if category != nil
      limit = 30
      take_num = 3

      ordered = self.find_by_category(category).order('weight DESC').limit(limit)
      get_row = []
      # ランダムに取得
      while get_row.length <= take_num
        random = Random.new
        r = random.rand(0..(limit - 1))
        if !get_row.include?(r) && !got_popular_tags.include?(r)
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

    return []
  end
end
