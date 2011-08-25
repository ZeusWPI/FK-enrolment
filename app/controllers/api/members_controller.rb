class Api::MembersController < Api::ApiController
  before_filter :load_member
  def load_member
    if params[:id]
      @member = Member.where(:enabled => true).find(params[:id], :include => :current_card)
      if !@member || @member.club_id != @club.id
        respond_with({:error => "Invalid member"}, :status => :forbidden)
      end
    end
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.includes(:current_card).where(:club_id => @club, :enabled => true)

    if params[:card]
      @members = @members.joins(:current_card).where('cards.number' => params[:card])
    end
    if params[:first_name]
      @members = @members.where("first_name LIKE ?", "%#{params[:first_name]}%")
    end
    if params[:last_name]
      @members = @members.where("last_name LIKE ?", "%#{params[:last_name]}%")
    end
    if params[:email]
      @members = @members.where(:email => params[:email])
    end
    if params[:ugent_nr]
      @members = @members.where(:ugent_nr => params[:ugent_nr])
    end

    respond_with(:api, @members)
  end

  # GET /members/1
  # GET /members/1.json
  def show
    respond_with(:api, @member)
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(unwrap_params(:member))
    @member.club = @club
    @member.enabled = true
    if @member.save
      flash[:notice] = "Successfully created member."
    end
    respond_with(:api, @member)
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    if @member.update_attributes(unwrap_params(:member))
      flash[:notice] = "Successfully updated member."
    end
    respond_with(:api, @member)
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    flash[:notice] = "Successfully destroyed member."
    respond_with(:api, @member)
  end
end
