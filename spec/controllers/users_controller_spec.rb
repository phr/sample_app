require 'spec_helper'

describe UsersController do
  render_views
  describe "GET 'new'" do
    before(:each) do
      @user = Factory(:user)
    end
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
      # Note that, in this context, rails converts get :show, :id=>@user to
      # get :show, :id=>@user.id by calling to_param on @user.  Hartl claims
      # this is a very common Rails idiom.
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
    it "should have the password fields as password type" do
      get :new
      response.should have_selector("form") do |f|
        f.should have_selector("input[id=user_password][type=password]")
        f.should have_selector(
                    "input[id=user_password_confirmation][type=password]")
      end
    end
  end
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end
  describe "Post 'create'" do
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
    end
  end
end
