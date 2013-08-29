module OmniAuthProvidersPatch
  extend ActiveSupport::Concern

  included do
    class_attribute :providers
    self.providers = []
    alias_method_chain :provider, :patch
  end

  def provider_with_patch(*args)
    self.class.providers << args.first
    provider_without_patch(*args)
  end
end

OmniAuth::Builder.send(:include, OmniAuthProvidersPatch)