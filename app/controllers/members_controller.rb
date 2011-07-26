class MembersController < ApiController
  # GET /members
  # GET /members.json
  def index
    @members = Member.all
    respond_with(@members)
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])
    respond_with(@member)
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(params[:member])
    if @member.save
      flash[:notice] = "Successfully created member."
    end
    respond_with(@member)
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      flash[:notice] = "Successfully updated member."
    end
    respond_with(@member)
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:notice] = "Successfully destroyed member."
    respond_with(@member)
  end
end
