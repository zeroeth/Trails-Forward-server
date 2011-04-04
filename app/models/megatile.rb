class Megatile < ActiveRecord::Base
  versioned
  
  belongs_to :world
  belongs_to :owner, :class_name => 'Player'
  has_many :resource_tiles
  
  has_many :megatile_grouping_megatiles
  has_many :megatile_groupings, :through => :megatile_grouping_megatiles
    
  def width
    world.megatile_width
  end
  
  def height
    world.megatile_height
  end
  
  def spawn_resources
    (x..(x + width - 1)).each do |x|
      (y..(y + height - 1)).each do |y|
        ResourceTile.create(:x => x, :y => y, :world => world, :megatile => self)
      end
    end
  end
  
  def listings(active_only = false)
    ret = Set.new
    megatile_groupings.each do |mg|
      listings = mg.listings
      if active_only
        listings = listings.where(:status => "Active")
      end
      
      listings.each do |l|
        ret << l
      end
    end
    return ret
  end
  
  def bids_on(active_only = true)
    ret = Set.new
    megatile_groupings.each do |mg|
      bids = mg.bids_on
      if active_only
        bids = bids.where(:status => Bid::Verbiage[:offered])
      end
      
      bids.each do |b|
        ret << b
      end
    end
    return ret
  end
  
  def bids_offering(active_only = true)
    ret = Set.new
    megatile_groupings.each do |mg|
      bids = mg.bids_offering
      if active_only
        bids = bids.where(:status => Bid::Verbiage[:offered])
      end
      
      bids.each do |b|
        ret << b
      end
    end
    return ret
  end
  
end
