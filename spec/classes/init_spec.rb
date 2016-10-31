require 'spec_helper'

describe 'mofed' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "RedHat",
        "operatingsystemrelease" => ["6", "7"],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/dne',
        })
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('mofed') }
      it { is_expected.to contain_class('mofed::params') }

      it { is_expected.to contain_anchor('mofed::start').that_comes_before('Class[mofed::repo]') }
      it { is_expected.to contain_class('mofed::repo').that_comes_before('Class[mofed::install]') }
      it { is_expected.to contain_class('mofed::install').that_comes_before('Class[mofed::config]') }
      it { is_expected.to contain_class('mofed::config').that_comes_before('Class[mofed::service]') }
      it { is_expected.to contain_class('mofed::service').that_comes_before('Anchor[mofed::end]') }
      it { is_expected.to contain_anchor('mofed::end') }

      include_context 'mofed::install'
      include_context 'mofed::config'
      include_context 'mofed::service'

      # Test validate_bool parameters
      [

      ].each do |param|
        context "with #{param} => 'foo'" do
          let(:params) {{ param.to_sym => 'foo' }}
          it 'should raise an error' do
            expect { is_expected.to compile }.to raise_error(/is not a boolean/)
          end
        end
      end

    end # end context
  end # end on_supported_os loop
end # end describe
