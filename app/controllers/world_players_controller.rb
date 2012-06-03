class WorldPlayersController < ApplicationController
  before_filter :authenticate_user!

  # GET /users/:id/players
  def index
    @players = World.find(params[:world_id]).players

    authorize! :index_user_players, @user

    if can? :access_private_data, @user
      template_to_use = :player_private
    else
      template_to_use = :player_public
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api template_to_use, :xml  => @players  }
      format.json  { render_for_api template_to_use, :json  => @players  }
    end
  end

  def bids_placed
    @player = Player.find(params[:player_id])
    authorize! :see_bids, @player

    @bids = @player.bids_placed
    if params.has_key? :active
      @bids = @bids.where(:status => Bid.verbiage[:active])
    end

    respond_to do |format|
      format.json { render_for_api :bid_private, :json => @bids, :root => :bids }
      format.xml  { render_for_api :bid_private, :xml  => @bids, :root => :bids }
    end
  end

  def bids_received
    @player = Player.find(params[:player_id])
    authorize! :see_bids, @player

    @bids = @player.bids_received

    if params.has_key? :active
      @bids = @bids.where(:status => Bid.verbiage[:active])
    end

    respond_to do |format|
      format.json { render_for_api :bid_private, :json => @bids, :root => :bids }
      format.xml  { render_for_api :bid_private, :xml  => @bids, :root => :bids }
    end
  end


  # POST /players

  def create
    authorize! :create_player, current_user
    @player = current_user.players.build params[:player]
    @player.world = World.find params[:world_id]
    @player.balance = Player.default_balance

    respond_to do |format|
      if @player.save
        format.xml  { render_for_api :player_private, :xml  => @player }
        format.json { render_for_api :player_private, :json => @player }
      else
        format.xml  { render :xml  => @player.errors, :status => :unprocessable_entity }
        format.json { render :json => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  def submit_turn
    world = World.find params[:world_id]
    player = world.player_for_user current_user
    authorize! :update_player, player

    player.last_turn_played = world.current_turn
    player.last_turn_played_at = DateTime.now

    respond_to do |format|
      if player.save
        format.xml  { render_for_api :player_private, :xml  => player }
        format.json { render_for_api :player_private, :json => player }
      else
        format.xml  { render :xml  => player.errors, :status => :unprocessable_entity }
        format.json { render :json => player.errors, :status => :unprocessable_entity }
      end
    end

  end
end