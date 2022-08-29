class WaitGroup
  # Create a new WaitGroup
  def initialize
    @count = 0_u64
    @channel = Channel(Nil).new
    @mtx = Mutex.new
  end

  def self.new
    this = new
    with this yield this
    this.wait
  end

  def wait
    Fiber.yield
    return if @count.zero?
    @channel.receive
  end

  def add
    @mtx.synchronize do
      @count += 1
    end
    puts "adding job, count = #{@count}"
    indicator = DoneIndicator.new self
    with indicator yield indicator
  end

  def spawn(&action)
    add do |i|
      ::spawn do
        action.call
        done
      end
    end
  end

  protected def done
    @mtx.synchronize do
      puts "done called, count = #{@count}"
      raise "Done called too many times" if @count <= 0
      @count -= 1
      @channel.send nil if @count == 0
    end
  end

  struct DoneIndicator
    def initialize(@wg : WaitGroup)
    end

    delegate :done, to: @wg
  end
end
