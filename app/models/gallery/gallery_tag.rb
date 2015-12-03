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
    if recommend_source_word.blank? || recommend_source_word.length == 0
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
    if category.present?
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


  def self.save_tag_category(tags)
    begin
      #  API使用のため別スレッドで実行
      Parallel.each(tags, in_threads: 2) do |tag|
        ActiveRecord::Base.connection_pool.with_connection do
          loop_max = 5

          # はてなキーワードでカテゴリを調べる
          client = XMLRPC::Client.new2("http://d.hatena.ne.jp/xmlrpc")
          client.http_header_extra = {'accept-encoding' => 'identity'}
          result = client.call("hatena.setKeywordLink", {
                                                          'body' => tag,
                                                          #mode: 'lite',
                                                          #score: 10
                                                      })
          category = nil
          if result['wordlist']
            category = result['wordlist'].first['cname']
          end

          loop_count = 0
          gallery_tag = self.find(tag.id)
          while gallery_tag.blank? && loop_count <= loop_max
            sleep 0.1
            loop_count += 1
            gallery_tag = self.find(tag.id)
          end

          if gallery_tag
            gallery_tag.category = category
            gallery_tag.save!
          end
        end
      end
    rescue => e
      return
    end
  end
end
