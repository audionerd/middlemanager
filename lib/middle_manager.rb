# encoding: UTF-8

require 'psych'
require 'yaml'
require 'yaml/store'
require 'fileutils'
require 'thor'

# Setup our load paths
libdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

module MiddleManager

  autoload :Server, "middle_manager/server"    

  #
  # TODO: Instead of using a simple Hash, eventually we should use special classes for each content type
  #         e.g., Text, Image, Article, Person, Product, File ...
  #
  # module Content
  #   class Base < Hash
  #     def initialize(*args)
  #       super(*args)
  #       @value = @value || "No content."
  #     end
  #     def value
  #       @value
  #     end
  #     def render
  #       value
  #     end
  #   end
  #   
  #   class Text < Base
  #     def initialize
  #       super
  #       @value = "Lorem Ipsum"
  #     end
  #   end
  # end

  class Store < YAML::Store
    class << self
      def generate_key(name, path)
        "%s@%s" % [path, name]
      end
    end
    
    def all
      transaction do
        roots.map do |name|
          Thor::CoreExt::HashWithIndifferentAccess.new self[name]
        end
      end
    end
    
    def get(key)
      transaction do
        Thor::CoreExt::HashWithIndifferentAccess.new self[key]
      end
    end
    
    def set(key, value)
      transaction do
        self[key] = value
      end
    end
    
    def delete_key(key)
      transaction do
        self.delete_key(key)
      end
    end    
  end
  
  class Manager
    attr_accessor :regions
    def initialize(options={})
      @store_dir = options[:store_dir]
      @filename = options[:filename] || 'middle_manager.yml'
            
      FileUtils.mkdir_p(@store_dir) unless File.exists?(@store_dir)
      @store = Store.new(File.join(@store_dir, @filename))

      @regions = Regions.new(@store)
    end
    def mgmt(obj, name, options)
      throw "mgmt: missing `name`" unless name

      path = options.delete(:path)
      throw "mgmt: missing `path`" unless path

      title = options.delete(:title)


      # TODO eventually we'll have custom classes serialized to YAML, not just a simple Hash
      # content = ::MiddleManager::Content::Base.new.merge({path: path, name: name, value: "Hello, world.", title: title, options: options })
      
      content = { path: path, name: name, value: "{{ mgmt #{name} }}", title: title, options: options }

      
      # TODO validate key (maybe enforce that only letters, numbers, spaces and underscores allowed for key?)
      # TODO use Store's .get / .set class methods here ...
      obj = @store.transaction do
        @store["%s@%s" % [path, name]] ||= content
      end
      obj = Thor::CoreExt::HashWithIndifferentAccess.new(obj)
      ::MiddleManager::Region.new(obj)
    end
    # TODO not sure if I like 'mgmt' for a key name, might do something more straightforward
    # alias :mgmt, :add_region
  end

  # hack! eventually this will decorate the Store front
  #       we should always be converting to regions ...
  #       until we figure out proper serialization, this could be a solution?
  class Regions
    def initialize(store)
      @store = store
    end
    def all
      @store.all
      # @store.all.map { |x|
      #   MiddleManager::Region.new(x)
      # }
    end
    def get(key)
      @store.get(key)
      # MiddleManager::Region.new(@store.get(key))
    end
    def set(key, value)
      @store.set(key, value)
    end
    # This goes direct. Not sure how else to do this ...
    def delete_key(key)
      @store.transaction do
        @store.delete(key)
      end
    end
  end

  class Region # < Thor::CoreExt::HashWithIndifferentAccess
    def initialize(content)
      @content = content
    end
    def render
      @content.value
    end
    # def store_key
    #   MiddleManager::Store.generate_key(@content.name, @content.path)
    # end
  end
end