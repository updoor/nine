require 'digest/sha1'
class MstUser < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  #attr_accessor :password

  # relations
  has_many :dat_projectusers, :dependent => :destroy, :foreign_key => :user_id
  has_many :dat_projects, :through => :dat_projectusers


  # validates
  validates_presence_of     :login_id, :email, :user_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_length_of       :login_id,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login_id, :email, :case_sensitive => false

  # before actions
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  # attr_accessible :login_id, :email, :password


  # attr
  def my_name
    user_name? ? user_name : email
  end


  # my projects
  def my_projects
    dat_projects.find(:all)
  end

  def my_active_projects
    o = {:conditions => ['dat_projectusers.active_flg = ?', 1]}
    dat_projects.find(:all, o)
  end


  # create new user
  def self.signup(params)
    user = MstUser.new(params)
    user.login_id = user.email
    user.password = self.create_password()
    user
  end

  def self.create_password
    base = "0123456789abcdefghijklmnopqrstuvwxyz"
    retpass = ""
    10.times{ |i| retpass << base[rand(base.length), 1] }
    retpass
  end


  # Model Object methods



  # authentication methods

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login_id, password)
    u = find_by_login_id(login_id) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login_id}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
end
