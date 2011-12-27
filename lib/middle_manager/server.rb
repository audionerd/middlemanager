require 'psych'
require 'yaml'
require 'yaml/store'
require 'sinatra/base'
require 'thor'

module MiddleManager
  class Server < Sinatra::Base

    use Rack::MethodOverride
    
    set :views, File.join(File.dirname(__FILE__), '..', '..', 'views')

    def manager
      @manager ||= Manager.new(store_dir:settings.middle_manager_data_dir, filename:'middle_manager.yml')
    end
        
    get '/' do
      @regions = manager.regions.all
      erb :index
    end

    get '/region/*/edit' do |splat|
      @regions = [] << manager.regions.get("/#{splat}")
      @region
      erb :'regions/edit'
    end
    
    post '/region' do
      for param in params
        if param.first && param.first.match(/^region_(.+)/)
          key = $1
          value = param.last
          
          # puts "Editing #{name} to be #{value}"
          manager.regions.set(key, manager.regions.get(key).merge({ value: value }))
        end
      end
      redirect to('/'), 303
    end

    delete '/region/*' do |splat|
      manager.regions.delete_key("/#{splat}")
      redirect to('/'), 303
    end

  end
end