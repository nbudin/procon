class ProposalsController < ApplicationController
  require_login
  before_filter :require_admin, :only => [:index, :review]
  
  def index
    if @context
      all_events = @context.events
    else
      all_events = Event.all
    end
    @events = all_events.select {|e| e.kind_of? ProposedEvent}
  end

  def new
    @event = ProposedEvent.new
    @event.proposer = logged_in_person
    if @context
      @event.parent = @context
    end
  end
  
  def create
    @event = ProposedEvent.new(params[:event])
    if @context
      @event.parent = @context
    end
    @event.proposer ||= logged_in_person
    
    if @event.save
      respond_to do |format|
        format.html { redirect_to(proposal_url(@event)) }
        format.json { redirect_to(formatted_proposal_url(@event, :json)) }
        format.xml  { redirect_to(formatted_proposal_url(@event, :xml)) }
      end
    else
      flash[:error_messages] += @event.errors.full_messages
      respond_to do |format|
        format.html { redirect_to(edit_proposal_url(@event)) }
        format.json { render :json => @event.errors.to_json }
        format.xml  { render :xml => @event.errors.to_xml }
      end
    end
  end
  
  def show
    @event = ProposedEvent.find(params[:id])
  end
  
  def review
    @event = ProposedEvent.find(params[:id])
  end
  
  protected
  
  def require_admin
    unless logged_in_person.permitted?(@context, "edit_events")
      access_denied "Sorry, only admins are permitted to view that page."
    end
  end
end