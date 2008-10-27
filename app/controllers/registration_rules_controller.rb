class RegistrationRulesController < ApplicationController
  before_filter :get_registration_rule_type, :only => [:new, :create]
  
  # GET /registration_rules
  # GET /registration_rules.xml
  def index
    @registration_rules = RegistrationRule.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @registration_rules.to_xml }
    end
  end

  # GET /registration_rules/1
  # GET /registration_rules/1.xml
  def show
    @registration_rule = RegistrationRule.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @registration_rule.to_xml }
    end
  end

  # GET /registration_rules/new
  def new
    @registration_rule = @rule_type.new
    render :partial => @rule_type.name.tableize.singularize
  end

  # GET /registration_rules/1;edit
  def edit
    @registration_rule = RegistrationRule.find(params[:id])
  end

  # POST /registration_rules
  # POST /registration_rules.xml
  def create
    @registration_rule = RegistrationRule.new(params[:registration_rule])

    respond_to do |format|
      if @registration_rule.save
        flash[:notice] = 'RegistrationRule was successfully created.'
        format.html { redirect_to registration_rule_url(@registration_rule) }
        format.xml  { head :created, :location => registration_rule_url(@registration_rule) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration_rule.errors.to_xml }
      end
    end
  end

  # PUT /registration_rules/1
  # PUT /registration_rules/1.xml
  def update
    @registration_rule = RegistrationRule.find(params[:id])

    respond_to do |format|
      if @registration_rule.update_attributes(params[:registration_rule])
        flash[:notice] = 'RegistrationRule was successfully updated.'
        format.html { redirect_to registration_rule_url(@registration_rule) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration_rule.errors.to_xml }
      end
    end
  end

  # DELETE /registration_rules/1
  # DELETE /registration_rules/1.xml
  def destroy
    @registration_rule = RegistrationRule.find(params[:id])
    @registration_rule.destroy

    respond_to do |format|
      format.html { redirect_to registration_rules_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def get_registration_rule_type
    if not RegistrationRule.rule_types.include?(params[:type])
      raise "#{params[:type]} is not a valid registration rule type"
    end
    
    @rule_type = eval(params[:type])
  end
end
