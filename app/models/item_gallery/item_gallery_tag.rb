class ItemGalleryTag < ActiveRecord::Base
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
          while gallery_tag == nil && loop_count <= loop_max
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
