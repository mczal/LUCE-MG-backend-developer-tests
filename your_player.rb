require './base_player.rb'

class YourPlayer < BasePlayer
  attr_accessor :number_of_step,
    :current_position, :next_point_result,
    :hopping

  def initialize game:, name:
    super(game:game, name:name)
    @hopping = nil
    @number_of_step = 0
    @seen_node = []
    # {
      # key: coordinate,
      # is_visited: boolean
      # cost: accumulate_weight
      # route: [arr_of_coord]
    # }
  end

  # Implement your strategy here.
  def next_point(time:)
    setup
    if @current_position == nil
      @seen_node << {
        key: {row:0,col:0},
        is_visited: true,
        cost: 0,
        additional_route: []
      }
      return @current_position = { row:0, col:0 }
    end

    see_path
    pick_shortest_path

    puts "Before Update Dynamic SEEN NODE: #{@seen_node}"
    puts "Before Update Dynamic NEXT POINT RESULT : #{next_point_result}"
    binding.pry
    update_dynamic

    puts "After Update Dynamic SEEN NODE: #{@seen_node}"
    puts "After Update Dynamic NEXT POINT RESULT : #{next_point_result}"
    binding.pry
    walk
  end

  def walk
    return @current_position = next_point_result[:key]
  end

  def update_dynamic
    #update to curr position cost
    curr = @seen_node.filter{|x|x[:key] == @current_position}.first
    curr[:cost] = next_point_result[:cost]


    #update to next position cost = 0
    target = @seen_node.filter{|x|x[:key] == next_point_result[:key]}.first
    target[:cost] = 0

    @seen_node.filter do |x|
      x[:key] != @current_position && x[:key] != next_point_result[:key]
    end.each do |entry|
      entry[:additional_route].unshift(@current_position)
      entry[:cost] = entry[:cost] + next_point_result[:cost]
    end
  end

  def pick_shortest_path
    candidates = @seen_node.filter{|x|!x[:is_visited]}
    sorted_candidates = candidates.sort_by{|entry| entry[:cost]}
    next_coord = sorted_candidates.first
    next_coord[:is_visited] = true
    @next_point_result = next_coord

    if next_coord[:additional_route].any?
      @hopping = {
        final_target: next_coord,
        additional_route: next_coord[:additional_route]
      }
    end


    # @not_chosen = sorted_candidates.last(sorted_candidates.size-1)
  end

  def see_path
    # see right
    row_right = @current_position[:row]
    col_right = @current_position[:col] + 1
    if col_right <= grid.max_col
      if @seen_node.filter{|x|x[:key] == {row:row_right,col:col_right}}.any?
      else
        weight = grid.edges[@current_position][{row:row_right,col:col_right}]
        @seen_node << {
          key: {row:row_right,col:col_right},
          is_visited: false,
          cost: weight,
          additional_route: []
        }
      end
    end
    # see left
    row_left = @current_position[:row]
    col_left = @current_position[:col] - 1
    if col_left >= 0
      if @seen_node.filter{|x|x[:key] == {row:row_left,col:col_left}}.any?
      else
        weight = grid.edges[@current_position][{row:row_left,col:col_left}]
        @seen_node << {
          key: {row:row_left,col:col_left},
          is_visited: false,
          cost: weight,
          additional_route: []
        }
      end
    end

    # see top
    row_top = @current_position[:row] + 1
    col_top = @current_position[:col]
    if row_top <= grid.max_row
      if @seen_node.filter{|x|x[:key] == {row:row_top,col:col_top}}.any?
      else
        weight = grid.edges[@current_position][{row:row_top,col:col_top}]
        @seen_node << {
          key: {row:row_top,col:col_top},
          is_visited: false,
          cost: weight,
          additional_route: []
        }
      end
    end

    # see bottom
    row_bottom = @current_position[:row] - 1
    col_bottom = @current_position[:col]
    if row_bottom >= 0
      if @seen_node.filter{|x|x[:key] == {row:row_bottom,col:col_bottom}}.any?
      else
        weight = grid.edges[@current_position][{row:row_bottom,col:col_bottom}]
        @seen_node << {
          key: {row:row_bottom,col:col_bottom},
          is_visited: false,
          cost: weight,
          additional_route: []
        }
      end
    end
  end

  def setup
    @number_of_step += 1
  end

  def grid
    game.grid
  end
end
