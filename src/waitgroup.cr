class WaitGroup
  VERSION = "0.1.0"

  struct DoneIndicator
    def initialize(@wg : WaitGroup)
    end

    delegate :done, to: @wg
  end

  setter minimum : UInt64

  # Create a new WaitGroup which waits for at least `minimum` number of jobs
  # to complete.
  def initialize(@minimum : UInt64 = 0_u64)
    @count = 0_u64
    @channel = Channel(Nil).new
    @mtx = Mutex.new
  end

  def self.new(minimum)
    this = new minimum.to_u64
    with this yield this
    this.wait
  end

  def wait
    @channel.receive
  end

  def add
    @mtx.synchronize do
      if @minimum == 0
        @count += 1
      else
        @minimum -= 1
        @count += 1
      end
    end
    indicator = DoneIndicator.new self
    with indicator yield indicator
  end

  protected def done
    @mtx.synchronize do
      raise "Done called too many times" if @count == 0
      @count -= 1
      @channel.send nil if @count == 0 == @minimum
    end
  end
end
