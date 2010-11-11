require "test_helper"
require "rack/mock"

class Rack::ZombieShotgunTest < Test::Unit::TestCase
  context "Request with method" do
    setup do
      app = Rack::ZombieShotgun.new(Proc.new {[200, {}, "Request Method"]})
      @request = Rack::MockRequest.new(app)
    end

    should "be passed on if not zombie method" do
      response = @request.get("/")
      assert_equal 200, response.status
    end

    should "be killed if OPTIONS" do
      response = @request.request("OPTIONS", "/")
      assert_equal 405, response.status
    end
  end

  context "Request with user agent" do
    setup do
      app = Rack::ZombieShotgun.new(Proc.new {[200, {}, "User Agent"]})
      @request = Rack::MockRequest.new(app)
    end

    should "be passed on if not zombie agent" do
      response = @request.get("/", "HTTP_USER_AGENT" => "Mozilla")
      assert_equal 200, response.status
    end

    should "be killed if FrontPage" do
      response = @request.get("/", "HTTP_USER_AGENT" => "FrontPage")
      assert_equal 404, response.status
    end

    should "be killed if Microsoft Office Protocol Discovery" do
      response = @request.get("/", "HTTP_USER_AGENT" => "Microsoft Office Protocol Discovery")
      assert_equal 404, response.status
    end

    should "be killed if Microsoft Data Access Internet Publishing Provider Protocol Discovery" do
      response = @request.get("/", "HTTP_USER_AGENT" => "Microsoft Data Access Internet Publishing Provider Protocol Discovery")
      assert_equal 404, response.status
    end
  end

  context "Request with directory" do
    setup do
      app = Rack::ZombieShotgun.new(Proc.new {[200, {}, "Directory"]})
      @request = Rack::MockRequest.new(app)
    end

    should "be passed on if not zombie directory" do
      response = @request.get("/")
      assert_equal 200, response.status
    end

    should "be killed if _vti_bin" do
      response = @request.get("/_vti_bin")
      assert_equal 404, response.status
    end

    should "be killed if MSOffice" do
      response = @request.get("/MSOffice")
      assert_equal 404, response.status
    end

    should "be killed if verify-VCNstrict" do
      response = @request.get("verify-VCNstrict")
      assert_equal 404, response.status
    end

    should "be killed if notified-VCNstrict" do
      response = @request.get("/notified-VCNstrict")
      assert_equal 404, response.status
    end
  end
end
