class ProposalsController < ActionController::Base
  def new
    @event = ProposedEvent.new
    if @context
      @event.parent = @context
    end
    calculate_edit_vars
  end
  
  def create
    @event = ProposedEvent.new(params[:event])
    if @context
      @event.parent = @context
    end
    @event.proposer ||= logged_in_person
    save_from_form
  end
end