require 'digest/md5'

class Feed < ActiveRecord::Base
  has_many :entries

  def secret
		Digest::MD5.hexdigest(created_at.to_s)
  end

  def notified params
  	# We could also save the feed's status... etc
  	params['items'].each do |i|
  		entries.create(:title => i["title"], :link => i["permalinkUrl"], :description => i["content"])
  	end
  end

end
