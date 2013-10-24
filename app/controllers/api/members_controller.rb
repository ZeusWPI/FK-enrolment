class Api::MembersController < Api::ApiController
  before_filter :load_member, :except => [:index, :create]

  skip_before_filter :verify_key, :only => [:clubs_for_ugent_nr]
  before_filter :verify_gandalf_key, :only => [:clubs_for_ugent_nr]

  def load_member
    @member, status = Member.find_member_for_club(params[:id], @club)
    unless @member
      respond_with({:error => "Invalid member"}, :status => status, :location => '')
    end
  end


  def clubs_for_ugent_nr
    ugent_nr = params[:ugent_nr]
    @clubs = Member.joins(:club).joins(:current_card).where(:ugent_nr => ugent_nr, cards: { status: "paid" }).pluck("clubs.internal_name")
    respond_with(:api, @clubs)
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.active_registrations
                     .includes(:current_card)
                     .where(:club_id => @club, :enabled => true)

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
    @member = Member.new unwrap_params(:member)
    @member.club = @club
    @member.enabled = true
    @member.save
    respond_with(:api, @member)
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @member.update_attributes unwrap_params(:member)
    respond_with(:api, @member)
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_with(:api, @member)
  end
end
