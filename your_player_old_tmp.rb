require './base_player.rb'

class YourPlayer < BasePlayer
  attr_accessor :next_point_result

  def initialize game:, name:
    super(game:game, name:name)
    @hopping = nil
    @seen_node = {}
    # {
      # key: coordinate,
      # is_visited: boolean
      # cost: accumulate_weight
      # additional_routes: [arr_of_coord]
    # }
  end

  # Implement your strategy here.
  def next_point(time:)
    if @current_position == nil
      @seen_node[{row:0,col:0}] = {
        key: {row:0,col:0},
        is_visited: true,
        cost: 0,
        additional_routes: []
      }
      return @current_position = { row:0, col:0 }
    end

    # puts "Before #see_path SEEN NODE: #{@seen_node}"
    # puts "Before #see_path NEXT POINT RESULT : #{next_point_result}"
    # binding.pry
    see_path

    # puts "Before #pick_shortest_path SEEN NODE: #{@seen_node}"
    # puts "Before #pick_shortest_path NEXT POINT RESULT : #{next_point_result}"
    # binding.pry
    pick_shortest_path

    # puts "Before #update_dynamic SEEN NODE: #{@seen_node}"
    # puts "Before #update_dynamic NEXT POINT RESULT : #{next_point_result}"
    # binding.pry
    update_dynamic

    walk
    # puts "After #walk SEEN NODE: #{@seen_node}"
    # puts "After #walk NEXT POINT RESULT : #{next_point_result}"
    # binding.pry
  end

  private
    def walk
      return @current_position = next_point_result[:key]
    end

    def update_dynamic
      @seen_node.filter do |k,v|
        k != @current_position && k != next_point_result[:key]
      end.each do |k,v|
        if v[:additional_routes].include?(next_point_result[:key])
          v[:additional_routes].delete(next_point_result[:key])
          v[:cost] = v[:cost] - next_point_result[:cost]
        else
          v[:additional_routes].unshift(@current_position)
          v[:cost] = v[:cost] + next_point_result[:cost]
        end
      end

      #update to curr position cost
      @seen_node[@current_position][:cost] = next_point_result[:cost]

      #update to next position cost = 0
      @seen_node[next_point_result[:key]][:cost] = 0
    end

    def pick_shortest_path
      if @hopping != nil
        if @hopping[:additional_routes].any?
          next_route_add = @hopping[:additional_routes].first
          @hopping[:additional_routes].delete(next_route_add)

          @next_point_result = @seen_node[next_route_add]
        else
          @next_point_result = @hopping[:final_target]
          @hopping = nil
          @next_point_result
        end

        @next_point_result[:is_visited] = true
        return
      end

      candidates = @seen_node.filter{|k,v|!v[:is_visited]}
      sorted_candidates = candidates.sort_by{|k,v| v[:cost]}
      top_candidate = sorted_candidates.first
      next_coord = top_candidate[1]

      if next_coord[:additional_routes].any?
        @hopping = {
          final_target: next_coord,
          additional_routes: next_coord[:additional_routes].dup
        }
        next_route_add = @hopping[:additional_routes].first
        @hopping[:additional_routes].delete(next_route_add)

        @next_point_result = @seen_node[next_route_add]
      else
        next_coord[:is_visited] = true
        @next_point_result = next_coord
      end
    end

    def see_path
      # see right
      row_right = @current_position[:row]
      col_right = @current_position[:col] + 1
      if col_right <= grid.max_col
        if @seen_node[{row:row_right,col:col_right}] != nil
          direct_weight_right = grid.edges[@current_position][{row:row_right,col:col_right}]

          curr_right = @seen_node[{row:row_right,col:col_right}]
          curr_cost = curr_right[:cost]

          if direct_weight_right <= curr_cost
            curr_right[:cost] = direct_weight_right
            curr_right[:additional_routes] = []
          end
        else
          weight = grid.edges[@current_position][{row:row_right,col:col_right}]
          @seen_node[{row:row_right,col:col_right}] = {
            key: {row:row_right,col:col_right},
            is_visited: false,
            cost: weight,
            additional_routes: []
          }
        end
      end

      # see left
      row_left = @current_position[:row]
      col_left = @current_position[:col] - 1
      if col_left >= 0
        if @seen_node[{row:row_left,col:col_left}] != nil
          direct_weight_left = grid.edges[@current_position][{row:row_left,col:col_left}]

          curr_left = @seen_node[{row:row_left,col:col_left}]
          curr_cost = curr_left[:cost]

          if direct_weight_left <= curr_cost
            curr_left[:cost] = direct_weight_left
            curr_left[:additional_routes] = []
          end
        else
          weight = grid.edges[@current_position][{row:row_left,col:col_left}]
          @seen_node[{row:row_left,col:col_left}] = {
            key: {row:row_left,col:col_left},
            is_visited: false,
            cost: weight,
            additional_routes: []
          }
        end
      end

      # see top
      row_top = @current_position[:row] + 1
      col_top = @current_position[:col]
      if row_top <= grid.max_row
        if @seen_node[{row:row_top,col:col_top}] != nil
          direct_weight_top = grid.edges[@current_position][{row:row_top,col:col_top}]

          curr_top = @seen_node[{row:row_top,col:col_top}]
          curr_cost = curr_top[:cost]

          if direct_weight_top <= curr_cost
            curr_top[:cost] = direct_weight_top
            curr_top[:additional_routes] = []
          end
        else
          weight = grid.edges[@current_position][{row:row_top,col:col_top}]
          @seen_node[{row:row_top,col:col_top}] = {
            key: {row:row_top,col:col_top},
            is_visited: false,
            cost: weight,
            additional_routes: []
          }
        end
      end

      # see bottom
      row_bottom = @current_position[:row] - 1
      col_bottom = @current_position[:col]
      if row_bottom >= 0
        if @seen_node[{row:row_bottom,col:col_bottom}] != nil
          direct_weight_bottom = grid.edges[@current_position][{row:row_bottom,col:col_bottom}]

          curr_bottom = @seen_node[{row:row_bottom,col:col_bottom}]
          curr_cost = curr_bottom[:cost]

          if direct_weight_bottom <= curr_cost
            curr_bottom[:cost] = direct_weight_bottom
            curr_bottom[:additional_routes] = []
          end
        else
          weight = grid.edges[@current_position][{row:row_bottom,col:col_bottom}]
          @seen_node[{row:row_bottom,col:col_bottom}] = {
            key: {row:row_bottom,col:col_bottom},
            is_visited: false,
            cost: weight,
            additional_routes: []
          }
        end
      end
    end

    def grid
      game.grid
    end
end
