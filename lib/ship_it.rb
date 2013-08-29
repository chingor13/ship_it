module ShipIt

  class << self
    attr_accessor :workspace, :log_dir
  end

  self.workspace = File.join(Dir.pwd, "workspace")
  self.log_dir = File.join(Dir.pwd, "log")
end
