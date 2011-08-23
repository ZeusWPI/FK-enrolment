class Backend::MembersController < Backend::BackendController

  respond_to :json, :xml
  def search
    @members = Member.where(:ugent_nr => params[:ugent_nr])
    render :partial => "show", :locals => { :members => @members }, :layout => false, :status => :created
  end

end
