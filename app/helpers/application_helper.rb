module ApplicationHelper

  def recent_failures
    @recent_failures ||= Environment.includes(:last_deployment).map(&:last_deployment).compact.select(&:failed?)
  end

  def in_progress
    @in_progress ||= Deployment.in_progress.all
  end

  def last_successful_duration(deployment)
    deployment.environment.last_successful_deployment &&
      deployment.environment.last_successful_deployment.duration
  end

  def progress_classes(deployment)
    lsd = last_successful_duration(deployment)
    ["progress", "progress-striped"].tap do |classes|
      if !lsd
        classes << "progress-warning"
      elsif !deployment.started?
      elsif deployment.duration > lsd
        classes << "progress-danger"
      else
        classes << "progress-success"
      end
      classes << "active" unless deployment.completed?
    end
  end

  def deployment_percent(deployment)
    lsd = last_successful_duration(deployment)
    if !lsd
      return 100
    elsif !deployment.started?
      return 0
    elsif deployment.duration > lsd
      return 100
    else
      return deployment.duration * 100 / lsd
    end
  end

  def time_remaining(deployment)
    if last_successful_deployment = deployment.environment.last_successful_deployment
      time_remaining = last_successful_deployment.duration - deployment.duration
      if time_remaining < 0
        "unknown"
      elsif time_remaining < 60
        "< 1 minute"
      else
        pluralize((time_remaining / 60).round, 'minute')
      end
    else
      "unknown"
    end
  end

  def duration_text(seconds)
    minutes = (seconds / 60.floor)
    seconds %= 60
    
    string = ""
    string << "#{minutes}m " if minutes
    string << "#{seconds}s"
    
    string
  end

end
