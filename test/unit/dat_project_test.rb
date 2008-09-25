require 'test_helper'

class DatProjectTest < ActiveSupport::TestCase
  def setup
    @current_user = MstUser.find(1)
  end
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_create_dat_project
    assert_difference 'DatProject.count' do
      dat_project = create_project
      assert !dat_project.new_record?,  "#{dat_project.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_project_name
    assert_no_difference 'DatProject.count' do
      p = create_project({ :project_name => nil})
      assert p.errors.on(:project_name)
    end
  end

  def test_should_require_project_cd
    assert_no_difference 'DatProject.count' do
      p = create_project({ :project_cd => nil})
      assert p.errors.on(:project_cd)
    end
  end

  def test_should_require_start_date
    assert_no_difference 'DatProject.count' do
      p = create_project({ :start_date => nil})
      assert p.errors.on(:start_date)
    end
  end

  def test_should_require_delivery_date
    assert_no_difference 'DatProject.count' do
      p = create_project({ :delivery_date => nil})
      assert p.errors.on(:delivery_date)
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
end
