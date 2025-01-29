require './base_player.rb'
require './brain.rb'

class YourPlayer < BasePlayer
  attr_accessor :next_point_result

  def initialize game:, name:
    super(game:game, name:name)
    @hopping = nil
  end

  # Implement your strategy here.
  def next_point(time:)
    if @current_position == nil
      return first_step_in_the_game
    end

    see_path
    pick_shortest_path
    update_dynamic

    walk
  end

  private
    def first_step_in_the_game
      node = Brain.create_seen_node!(
        key: {row:0,col:0},
        cost: 0,
        additional_routes: [],
        player: self
      )
      @next_point_result = node
      walk
    end
    def walk
      @current_position = next_point_result
      @current_position.key
    end

    def update_dynamic
      return if @current_position == next_point_result

      Brain.filter_seen_nodes_by_not(
        key: [@current_position.key, next_point_result.key],
        # additional_route: next_point_result.key,
        player: self
      ).each do |seen_node|
        if seen_node.additional_routes_for(self).include?(next_point_result.key)
          seen_node.remove_additional_route_for(self, next_point_result.key)

          new_cost = seen_node.cost_for(self) - next_point_result.cost_for(self)
          seen_node.set_cost_for(self, new_cost)
        else
          seen_node.add_additional_route_for(self, @current_position.key)
          new_cost = seen_node.cost_for(self) + next_point_result.cost_for(self)
          seen_node.set_cost_for(self, new_cost)
        end
      end

      #update to curr position cost
      @current_position.set_cost_for(self, next_point_result.cost_for(self))

      #update to next position cost = 0
      next_point_result.set_cost_for(self, 0)
    end


    def pick_shortest_path
      if @hopping != nil
        if @hopping[:additional_routes].any?
          next_route_add = @hopping[:additional_routes].first
          @hopping[:additional_routes].delete(next_route_add)

          @next_point_result = Brain.find_seen_node_by(key: next_route_add, player: self)
        else
          @next_point_result = @hopping[:final_target]
          @hopping = nil
        end

        return
      end

      next_node = Brain.get_most_cheap_unvisited_node_for(self)
      if next_node == nil
        # there is no unvisited node left
        @next_point_result = @current_position # stay
        return
      end

      next_node_additional_routes = next_node.additional_routes_for(self)
      if next_node_additional_routes.any?
        @hopping = {
          final_target: next_node,
          additional_routes: next_node_additional_routes.dup
        }
        next_route_add = @hopping[:additional_routes].shift
        @next_point_result = Brain.find_seen_node_by(key: next_route_add, player: self)
      else
        @next_point_result = next_node
      end
    end


    def see_path
      # see right
      key_right = get_key_to_see :right
      update_my_seeing_sight(key_right)

      # see left
      key_left = get_key_to_see :left
      update_my_seeing_sight(key_left)

      # see top
      key_top = get_key_to_see :top
      update_my_seeing_sight(key_top)

      # see bottom
      key_bottom = get_key_to_see :bottom
      update_my_seeing_sight(key_bottom)
    end

    def update_my_seeing_sight seeing_coordinate
      if grid.is_valid_move?(from: @current_position.key, to: seeing_coordinate)
        node = Brain.find_seen_node_by(key: seeing_coordinate, player: self)
        direct_cost_bottom = grid.edges[@current_position.key][seeing_coordinate]

        if node != nil && node.player_attributes[self] != nil
          existing_cost = node.cost_for(self)

          if direct_cost_bottom <= existing_cost
            node.set_cost_for(self, direct_cost_bottom)
            node.set_additional_routes_for(self, [])
          end
        else
          Brain.create_seen_node!(
            key: seeing_coordinate,
            cost: direct_cost_bottom,
            additional_routes: [],
            player: self
          )
        end
      end
    end

    def get_key_to_see direction
      if direction == :right
        return {
          row: @current_position.key[:row],
          col: @current_position.key[:col] + 1,
        }
      end
      if direction == :left
        return {
          row: @current_position.key[:row],
          col: @current_position.key[:col] - 1,
        }
      end
      if direction == :top
        return {
          row: @current_position.key[:row] + 1,
          col: @current_position.key[:col],
        }
      end
      if direction == :bottom
        return {
          row: @current_position.key[:row] - 1,
          col: @current_position.key[:col],
        }
      end
    end

    def grid
      game.grid
    end

    def print_debug
      puts <<-EOS

      I'm #{self.name}
      >> Current Position: #{@current_position.key} <<
      >> Next Position: #{next_point_result.key} <<
      EOS
      Brain.print_debug
    end
end
