class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
    def self.store(session)
        shop = self.new(domain: session.url, token: session.token)
        shop.save!
        shop.id
    end

  def self.retrieve(id)
    if shop = self.where(id: id).first
      ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
    end
  end
  
end
