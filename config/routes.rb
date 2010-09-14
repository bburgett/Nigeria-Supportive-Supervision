ActionController::Routing::Routes.draw do |map|

  map.data_response_start "data_responses/:id", :controller => 'data_responses', :action => 'start'

  map.data_response_edit "data_responses/:id/edit", :controller => 'data_responses', :action => 'edit'

  map.data_requests 'data_requests', :controller => 'data_requests', :action => :index #until we flesh out this model

  # routes for CSV uploading for various models
  %w[model_helps comments organizations users].each do |model|
    map.create_from_file model+"/create_from_file", :controller => model, :action => "create_from_file"
    map.create_from_file_form model+"/create_from_file_form", :controller => model, :action => "create_from_file_form"
  end

  map.providers_data_entry "providers",
    :controller => 'providers', :action => 'index'

  map.resources :projects,
    :collection => {:browse => :get},
    :member => {:select => :post}, :active_scaffold => true

  map.resources :organizations,
    :collection => {:browse => :get},
    :member => {:select => :post}, :active_scaffold => true

  map.resources :comments, :active_scaffold => true
  map.resources :field_helps, :active_scaffold => true
  map.resources :model_helps, :active_scaffold => true
  map.resources :codes, :active_scaffold => true

  map.resources :users, :active_scaffold => true
  map.resource :user_session

  map.resources :help_requests, :active_scaffold => true

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  map.reporter_dashboard "reporter_dashboard", :controller => 'static_page', :action => "reporter_dashboard"

  # do not remove, these routes make the pages accessible without security checks
  %w[about news contact].each do |p|
    map.send(p.to_sym, p, :controller => 'static_page', :action => p)
  end

  #reports
  #map.activities_by_district 'activities_by_district', :controller => 'reports', :action => 'activities_by_district'

  map.static_page ':page',
                  :controller => 'static_page',
                  :action => 'show',
                  :page => Regexp.new(%w[about contact admin_dashboard about news submit user_guide reports].join('|'))

  map.root :controller => 'static_page', :action => 'index' # a replacement for public/index.html

end
