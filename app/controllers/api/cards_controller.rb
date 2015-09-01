class Api::CardsController < Api::ApiController
  before_filter :load_card
  def load_card
    @member = Member.find(params[:member_id])
    @card = @member.current_card || Card.build_for(@member)

    if @member.club_id != @club.id
      respond_with({:error => "Invalid member"}, :status => :forbidden)
    end
  end

  # GET /members/1/card.json
  def show
    respond_with(:api, @card.member, @card)
  end

  # POST /members/1/card.json
  def create
    @card.attributes = unwrap_params(:card)
    if @card.save
      @card.delay.export_to_isic unless @card.isic_exported
      flash[:notice] = "Successfully updated card."
    end
    respond_with(:api, @card.member, @card)
  end
end
