require "./spec_helper"

describe WaitGroup do
  it "works" do
    wg = WaitGroup.new
    time_taken = Time.measure do
      10.times do
        spawn do
          wg.add do
            sleep 1
            done
          end
        end
      end
      wg.wait
    end
    time_taken.should be_close 1.second,
      delta: 0.1.seconds
  end

  it "works when yielded to a block" do
    time_taken = Time.measure do
      WaitGroup.new do |wg|
        add do |i|
          spawn do
            sleep 1
            i.done
          end
        end
        spawn do
          wg.add do
            sleep 1
            done
          end
        end
      end
    end

    time_taken.should be_close 1.second,
      delta: 0.1.seconds
  end

  it "is reusable" do
    time_taken = Time.measure do
      WaitGroup.new do
        spawn do
          sleep 1.second
        end
        wait
        spawn do
          sleep 1.second
        end
        wait
      end
    end.should be_close 2.seconds, delta: 0.1.seconds
  end
end
