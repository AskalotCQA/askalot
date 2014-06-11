module RemoteHelper
  def wait_for_remote(time = nil)
    sleep time if time

    Timeout.timeout(10) do
      sleep 0.1 until page.evaluate_script('jQuery.active') == 0
    end

    sleep 1
  end
end
