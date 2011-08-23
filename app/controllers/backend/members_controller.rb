class Backend::MembersController < Backend::BackendController

  def search
    @members = Member.where(:ugent_nr => params[:ugent_nr])
    respond_to do |format|
      format.js
    end
  end

end
