require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'middle_manager'))

map "/admin" do
  DATA_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'middle-managed-app', 'data')) 
  ::MiddleManager::Server.set :middle_manager_data_dir, DATA_PATH
  run ::MiddleManager::Server
end