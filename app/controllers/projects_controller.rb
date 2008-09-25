class ProjectsController < ApplicationController

  # user dashboard
  def index
  end

  # project dashboard
  def show
    
  end


  def wbs
  end

  def gantt
  end

  def calendar
  end


  def new
    @dat_project = DatProject.new
  end

  def create
    @dat_project = DatProject.new_project(params[:dat_project], @current_mst_user)
    @dat_project.save
    if @dat_project.errors.empty?
      @current_project = @dat_project
      redirect_to project_path({:id => @current_project.project_cd})
      flash[:notice] = "Created new project sucessful"
    else
      render :action => 'new'
    end
  end
end
