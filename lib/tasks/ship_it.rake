require 'pp'

namespace :ship_it do
  desc 'Polls for changes and deploys'
  task :run => :environment do
    threads = []
    deployment_threads = {}
    
    # wait for deployments to finish before terminating
    Signal.trap("SIGTERM") do
      puts "Waiting for threads to finish ..."
      
      while(threads.any?(&:alive?))
        sleep(1)
      end
      
      exit
    end

    # terminate immediately
    Signal.trap("SIGINT") do
      puts "Terminating threads ..."

      threads.each do |thread|
        thread.raise(Interrupt) if thread.alive?
      end
      
      exit
    end
    
    # cleanup old deployments
    Deployment.in_progress.each do |deployment|
      last_log_time = File.ctime(deployment.log_file) if deployment.log_file
      deployment.update_attributes(:finished_at => last_log_time || Time.now, :success => false)
    end
      
    # main loop
    begin
      # remove terminated threads from lists
      threads.select! { |thread| thread.alive? }
      deployment_threads.select! { |id, thread| thread.alive? }
      
      # terminate deployments
      Deployment.awaiting_termination.each do |deployment|
        thread = deployment_threads[deployment.id]
        thread.raise(Interrupt) if thread && thread.alive?
      end
      
      # poll git for changes
      threads << Thread.start do
        Project.includes(:branches, :environments).each do |project|
          project.poll!
        end
      end
    
      # kickoff deployments
      Deployment.pending.each do |deployment|
        deployment.update_attributes(:started_at => Time.now)
        
        threads << Thread.start do
          begin
            deployment.deploy!
          rescue => e
            pp e
            pp e.backtrace
          end
        end
        
        deployment_threads[deployment.id] = threads.last
      end
      
      sleep(5)
    end while true
    
  end
end
