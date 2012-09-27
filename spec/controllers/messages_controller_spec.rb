require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe MessagesController do
  include Devise::TestHelpers
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Message. As you add validations to Message, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    message = build :message
    message.attributes
  end


  let!(:message)  { create(:message, sender: player2, recipient: logged_in_player) }
  let!(:message_to_other_player)  { create(:message, sender: logged_in_player, recipient: player2) }
  let!(:logged_in_player) { create :player }
  let!(:player2) { create :player }
  let(:world) { message.recipient.world }
  let(:shared_params) { {world_id: world.to_param, format: 'json'} }

  before do
    sign_in logged_in_player.user
  end

  describe "GET #index" do
    it "assigns all messages as @messages" do
      get :index, shared_params
      response.should be_successful
      response.body.should have_content(message.body)
    end
  end

  describe "GET #show" do
    it "assigns the requested message as @message" do
      get :show, shared_params.merge(id: message.to_param)
      response.should be_successful
      response.body.should have_content(message.body)
    end
  end

  describe "POST #create" do
    it "creates a new Message" do
      expect {
        post :create, shared_params.merge(:message => valid_attributes.merge(:recipient_id => player2.id))
      }.to change(Message, :count).by(1)

      message = Message.last
      message.sender.should == logged_in_player
      message.recipient.should == player2
    end
  end

  describe 'PUT #update' do
    it 'changes attributes' do
      put :update, shared_params.merge(id: message.to_param, message: { subject: 'New Subject' })
      Message.find(message).subject.should == "New Subject"
    end
  end

  describe 'PUT #archive' do
    it 'marks message archived' do
      Message.find(message).archived?.should == false
      put :archive, shared_params.merge(id: message.to_param)
      Message.find(message).archived?.should == true
    end
  end

  describe 'PUT #read' do
    it 'marks message read' do
      Message.find(message).read?.should == false
      put :read, shared_params.merge(id: message.to_param)
      Message.find(message).read?.should == true
    end
  end
end
