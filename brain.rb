require './seen_node.rb'

class Brain
  class << self
    attr_accessor :game

    def get_most_cheap_unvisited_node_for player
      self.filter_seen_nodes_by(is_visited: false,player:player).sort_by do |seen_node|
        seen_node.player_attributes[player][:cost]
      end.first
    end

    def create_seen_node! attributes
      # seen_node = self.find_seen_node_by(key: attributes[:key], player: attributes[:player])
      seen_node = self.seen_nodes.filter{|seen_node|seen_node.key == attributes[:key]}.first

      if seen_node == nil
        new_seen_node = SeenNode.new(**attributes)
        self.seen_nodes << new_seen_node
        return new_seen_node
      end

      if seen_node.player_attributes[attributes[:player]] != nil
        raise "ERROR same person initializing same seen node twice"
      end
      seen_node.player_attributes[attributes[:player]] = {
        cost: attributes[:cost],
        additional_routes: attributes[:additional_routes]
      }
      seen_node
    end

    def filter_seen_nodes_by args
      query = []
      player = args.delete(:player)
      raise 'player args not present' if player == nil

      query << "seen_node.player_attributes[player] != nil"
      args.each do |k,v|
        if k == :additional_route
          # query << "seen_node.send(:#{k}s).include?(#{v})"
          query << "seen_node.player_attributes[player][:additional_routes].include?(#{v})"
        elsif k == :cost
          # query << "seen_node.send(:#{k}s).include?(#{v})"
          query << "seen_node.player_attributes[player][:cost] == #{v}"
        elsif v.is_a?(Array)
          query << "#{v}.include?(seen_node.send(:#{k}))"
        else
          query << "seen_node.send(:#{k}) == #{v}"
        end
      end

      self.seen_nodes.filter do |seen_node|
        eval(query.join(' && '))
      end
    end
    def filter_seen_nodes_by_not args
      query = []
      player = args.delete(:player)
      raise 'player args not present' if player == nil

      query << "seen_node.player_attributes[player] != nil"
      args.each do |k,v|
        if k == :additional_route
          # query << "seen_node.send(:#{k}s).include?(#{v})"
          query << "!seen_node.player_attributes[player][:additional_routes].include?(#{v})"
        elsif k == :cost
          # query << "seen_node.send(:#{k}s).include?(#{v})"
          query << "seen_node.player_attributes[player][:cost] != #{v}"
        elsif v.is_a?(Array)
          query << "!#{v}.include?(seen_node.send(:#{k}))"
        else
          query << "seen_node.send(:#{k}) != #{v}"
        end
      end

      self.seen_nodes.filter do |seen_node|
        eval(query.join(' && '))
      end
    end

    def find_seen_node_by args
      filter_seen_nodes_by(args).first
    end

    def number_of_seen_nodes
      self.seen_nodes.count
    end

    def destroy_all_seen_nodes
      @seen_nodes = []
    end

    def print_debug
      self.seen_nodes.each.with_index(1) do |seen_node,i|
        puts <<-EOS

          [#{i}]===
          key: #{seen_node.key},
          is_visited: #{seen_node.is_visited},

        EOS
        seen_node.player_attributes.each do |k,v|
          puts <<-EOS
          -- BEGIN Player: #{k.name} --
          cost = #{v[:cost]}
          additional_routes = #{v[:additional_routes]}
          -- END Player: #{k.name} --
          EOS
        end
        puts <<-EOS
          ===

        EOS
      end

      ''
    end

    private
      def seen_nodes
        @seen_nodes ||= []
      end
  end
end
