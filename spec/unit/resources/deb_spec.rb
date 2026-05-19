# frozen_string_literal: true

require 'spec_helper'

describe 'reprepro_deb' do
  step_into :reprepro_deb
  platform 'ubuntu', '24.04'

  context 'with action add' do
    before do
      stub_command("test -f '/tmp/example_1.0.0_amd64.deb' && test \"$(reprepro -b '/srv/apt' list 'noble' $(dpkg-deb -f '/tmp/example_1.0.0_amd64.deb' package) | awk '{ print $3 }')\" = \"$(dpkg-deb -f '/tmp/example_1.0.0_amd64.deb' version)\"").and_return(false)
    end

    recipe do
      reprepro_deb '/tmp/example_1.0.0_amd64.deb' do
        distribution 'noble'
        action :add
      end
    end

    it { is_expected.to run_execute('Add deb package example_1.0.0_amd64.deb to noble') }
  end

  context 'with action remove' do
    before do
      stub_command("reprepro -b '/srv/apt' list 'noble' 'example' | grep -q .").and_return(true)
      stub_command("reprepro -b '/srv/apt' list 'jammy' 'example' | grep -q .").and_return(true)
    end

    recipe do
      reprepro_deb '/tmp/example_1.0.0_amd64.deb' do
        package_name 'example'
        distribution %w(noble jammy)
        action :remove
      end
    end

    it { is_expected.to run_execute('Remove package example from noble') }
    it { is_expected.to run_execute('Remove package example from jammy') }
  end
end
