class DatProjectuser < ActiveRecord::Base

  # relations
  belongs_to :mst_user, :foreign_key => 'user_id'
  belongs_to :dat_project, :foreign_key => 'project_id'



  def self.add(project, user, create_user=nil)
    create_user ||= user
    params = {
      :project_id => project.id,
      :user_id    => user.id,
      :email      => user.email,
      :create_user_id => create_user.id,
    }
    pu =  DatProjectuser.new(params)
    pu.save
    pu
  end
end
