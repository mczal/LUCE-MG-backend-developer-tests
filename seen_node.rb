require './brain.rb'

class SeenNode
  attr_reader :key
  attr_accessor :player_attributes

  def initialize key:,cost:,additional_routes:[],player:
    @key = key
    @player_attributes = {}
    @player_attributes[player] = {
      cost: cost,
      additional_routes: additional_routes
    }
  end

  def is_visited
    !!Brain.game.grid.visited[self.key]
  end

  def cost_for player
    self.player_attributes[player][:cost]
  end
  def set_cost_for player, cost
    self.player_attributes[player][:cost] = cost
  end

  def additional_routes_for player
    self.player_attributes[player][:additional_routes]
  end
  def set_additional_routes_for player, additional_routes
    self.player_attributes[player][:additional_routes] = additional_routes
  end
  def remove_additional_route_for player, additional_route
    self.player_attributes[player][:additional_routes].delete(additional_route)
  end
  def add_additional_route_for player, additional_route
    self.player_attributes[player][:additional_routes].unshift(additional_route)
  end
end
