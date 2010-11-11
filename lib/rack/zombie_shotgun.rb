require 'set'

module Rack
  class ZombieShotgun
    ZOMBIE_AGENTS = ['Microsoft Office Protocol Discovery',
      'Microsoft Data Access Internet Publishing Provider Protocol Discovery',
      'FrontPage'].to_set.freeze
    ZOMBIE_DIRS  = ['_vti_bin','MSOffice', 'verify-VCNstrict',
      'notified-VCNstrict'].to_set.freeze
    ZOMBIE_METHODS = [:options].to_set.freeze

    def initialize(app, options = {})
      @app = app
      @options = {
        :agents => true,
        :directories => true,
        :methods => true
      }.merge(options)
    end

    def call(env)
      @request = Rack::Request.new(env)
      return head_not_found if zombie_dir_attack?
      return head_not_found if zombie_agent_attack?
      return method_not_allowed if zombie_method_attack?
      @app.call(env)
    end

    private

    def head_not_found
      [404, {"Content-Length" => "0"}, []]
    end

    def method_not_allowed
      [405, {"Content-Length" => "0"}, []]
    end

    def zombie_dir_attack?
      paths = @request.path_info
      @options[:directories] && ZOMBIE_DIRS.any? {|dir| paths.include?(dir)}
    end

    def zombie_agent_attack?
      agent = @request.env['HTTP_USER_AGENT']
      @options[:agents] && agent && ZOMBIE_AGENTS.include?(agent)
    end

    def zombie_method_attack?
      method = @request.env["REQUEST_METHOD"]
      @options[:methods] && ZOMBIE_METHODS.include?(method.downcase.to_sym)
    end
  end
end
