class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 3}, on: :create

  sluggable_column :username

  def sorted_posts
    posts.all.sort_by{ |x| x.net_votes }.reverse
  end

  def sorted_comments
    comments.all.sort_by{ |x| x.net_votes }.reverse
  end

  def is_admin?
    role == 'admin'
  end

  def render_pin!
    update_column(:pin, rand(10 ** 6))
  end

  def two_factor?
    !phone.blank?
  end

  def clear_pin!
    update_column(:pin, nil)
  end

  def send_pin_through_twilio
    account_sid = 'AC7b1cbf55335aa37003003422c11313e0'
    auth_token = '20e2dada6fc5a5930680ec42fe7c8764'
    # set up a client to talk to the Twilio REST API
    client = Twilio::REST::Client.new account_sid, auth_token
    client.account.messages.create({
    	:from => '+17604073063',
    	:to => "#{self.phone}",
    	:body => "Your pin is #{self.pin}.",
    })
  end

end
