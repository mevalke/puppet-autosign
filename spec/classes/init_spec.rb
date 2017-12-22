require 'spec_helper'
describe 'puppet_autosign' do
  context 'with default values for all parameters' do
    it { should contain_class('puppet_autosign') }
  end
end
