require 'spec_helper'
require 'facter/util/file_read'
require 'facter/util/mellanox_infiniband'

describe Facter::Util::MellanoxInfiniband do

  before :each do
    Facter.clear
  end

  describe 'lspci' do
    it 'should return output' do
      expect(Facter::Util::Resolution).to receive(:exec).with('lspci -n 2>/dev/null').and_return('foo')
      expect(Facter::Util::MellanoxInfiniband.lspci).to eq('foo')
    end
  end

  describe 'count_ib_devices' do
    it 'should return count' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return('/usr/bin/lspci')
      allow(described_class).to receive(:lspci).and_return(my_fixture_read('mellanox_lspci_1'))
      expect(described_class.count_ib_devices).to eq(1)
    end

    it 'should return 0 count for noib' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return('/usr/bin/lspci')
      allow(described_class).to receive(:lspci).and_return(my_fixture_read('noib_lspci_1'))
      expect(described_class.count_ib_devices).to eq(0)
    end

    it 'should return 0 count for qlogic' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return('/usr/bin/lspci')
      allow(described_class).to receive(:lspci).and_return(my_fixture_read('qlogic_lspci_1'))
      expect(described_class.count_ib_devices).to eq(0)
    end

    it 'should not return count if no lspci' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return(nil)
      expect(described_class).not_to receive(:lspci)
      expect(described_class.count_ib_devices).to eq(0)
    end
  end
end
