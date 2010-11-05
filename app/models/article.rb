class Article < ActiveRecord::Base
 has_many :gallery_items
 belongs_to :article_category
end
