require 'spec_helper'
describe 'puppet-autosign' do
  context 'with default values for all parameters' do
    it { should contain_class('puppet-autosign') }
  end
end
