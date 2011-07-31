class CardsController < ApiController
  before_filter :load_card
  def load_card
    if params[:member_id]
      @card = Card.where(:member_id => params[:member_id]).first!
      if @card.member.club_id != @club.id
        respond_with({:error => "Invalid member"}, :status => :forbidden)
      end
    end
  end

  # GET /members/1/card.json
  def show
    respond_with(@card.member, @card)
  end

  # POST /members/1/card.json
  def create
    @card = Card.new(params[:card])
    @card.member_id = params[:member_id]
    if @card.save
      flash[:notice] = "Successfully created card."
    end
    respond_with(@card.member, @card)
  end

  # PUT /members/1/card.json
  def update
    if @card.update_attributes(params[:card])
      flash[:notice] = "Successfully updated card."
    end
    respond_with(@card.member, @card)
  end

  # DELETE /members/1/card.json
  def destroy
    @card.destroy
    flash[:notice] = "Successfully destroyed card."
    respond_with(@card.member, @card)
  end
end
