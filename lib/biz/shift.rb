module Biz
  class Shift

    extend Forwardable

    include Comparable

    def initialize(time_segment)
      @time_segment = time_segment
    end

    def date
      @date ||= time_segment.start_time.to_date
    end

    delegate contains?: :time_segment

    protected

    attr_reader :time_segment

    private

    def <=>(other)
      return unless other.is_a?(self.class)

      time_segment <=> other.time_segment
    end

    public

    def to_time_segment
      time_segment
    end

  end
end
