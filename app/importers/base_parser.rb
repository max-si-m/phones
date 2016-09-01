class BaseParser
  def initialize
    @@agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
  end
end
