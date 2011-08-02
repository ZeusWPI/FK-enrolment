class Api::MembersController < Api::ApiController
  before_filter :load_member
  def load_member
    if params[:id]
      @member = Member.find(params[:id], :include => :current_card)
      if @member.club_id != @club.id
        respond_with({:error => "Invalid member"}, :status => :forbidden)
      end
    end
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.where(:club_id => @club).includes(:current_card).all
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
    @member = Member.new(params[:member])
    @member.club = @club
    if @member.save
      flash[:notice] = "Successfully created member."
    end
    respond_with(:api, @member)
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    if @member.update_attributes(params[:member])
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
