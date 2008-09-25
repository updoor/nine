class DatProject < ActiveRecord::Base

  # relations
  has_many :dat_projectusers, :dependent => :destroy, :foreign_key => 'project_id'
  has_many :mst_users, :through => :dat_projectusers

  # validates
  validates_presence_of   :project_name
  validates_presence_of   :project_cd
  validates_presence_of   :start_date
  validates_presence_of   :delivery_date
  validates_length_of     :project_cd, :within => 3..16
  validates_uniqueness_of :project_cd

  # accessor
  attr_accessor :created_user

  # filters
  #after_create :create_users

  def from_to
    
  end

  def code
    project_cd? ? project_cd : id
  end

  def users
    @users ||= mst_users.find(:all, {:conditions => ["dat_projectusers.active_flg = ?", 1]})
  end







  def self.new_project(params, current_user, users=[])
    p = DatProject.new(params)
    p.create_user_id = current_user
    p.update_user_id = current_user
    p.end_user_name  ||= current_user.my_name
    if p.save
       p.create_users([current_user], current_user)
    end
    p
  end




  def create_users(users, create_user)
    project_users = []
    users.each do |user|
      project_users << dat_projectusers.add(self, user, create_user)
    end
    project_users
  end

end
