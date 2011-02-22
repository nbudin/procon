ActionController::Routing::Routes.draw do |map|
  map.resources :proposed_events

  map.resources :locations

  map.resources :schedules, :member => { :health => :get }
  map.resources :registration_rules
  
  map.dropout "dropout/:event", :controller => "signup", :action => "dropout"
  map.signup "signup/:event", :controller => "signup", :action => "signup"

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  map.root :controller => "main"
  
  map.resources :events, :collection => {:schedule => :get, :propose => :get, :submit_proposal => :post}, :member => {:available_people => :get} do |events|
    events.resources :attendances, :collection => { :children => :get }
  end
  
  map.resources :site_templates, :member => {:themeroller => :get} do |site_templates|
    site_templates.resources :attached_images
  end
  
  map.resources :virtual_sites

  # site contexts - so we know what our local event parent is
  map.connect 'c/:context', :controller => "main"
  map.connect 'c/:context/:controller/:action/:id.:format'
  map.connect 'c/:context/:controller/:action/:id'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
