require 'test_helper'

class DatProjectuserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def setup
    @current_user = MstUser.find(1)
  end
  
  def test_add
    p = create_project
    u = create_mst_user
    assert_difference 'DatProjectuser.count' do
      pu = DatProjectuser.add(p, u)
      assert !pu.new_record?, "#{pu.errors.full_messages.to_sentence}"
    end
  end
  

  protected
  def create_project(options={})
    r = DatProject.new_project({
                                 :project_name => 'new project',
                                 :project_cd => 'new_project',
                                 :end_user_name => 'quire',
                                 :start_date => '2009-09-01',
                                 :delivery_date => '2008-09-30'}.merge(options), @current_user)
    r.save
    r
  end

  def create_mst_user(options = {})
    record = MstUser.signup({:email => 'quire@example.com', :user_name => 'quire', :company_name => '9arrows'}.merge(options))
    record.save
    record
  end
end
