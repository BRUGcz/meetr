require 'digest/md5'

class Account < ActiveRecord::Base
  belongs_to :user


  def gravatar
    hash = Digest::MD5.hexdigest(self.user.email)
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def bio_to_html
    Maruku.new(self.bio).to_html
  end

end
