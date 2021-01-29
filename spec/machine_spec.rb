# frozen_string_literal: true

require_relative '../lib/scrooger/machine'

RSpec.describe 'Scrooger::Machine' do
  let(:mc) do
    instance_mock = instance_double('Aws::EC2::Instance')
    allow(instance_mock).to receive(:start).and_return(true)
    allow(instance_mock).to receive(:stop).and_return(true)
    state_mock = instance_double('Aws::EC2::InstanceState')
    allow(state_mock).to receive(:code).and_return(status_code)
    allow(instance_mock).to receive(:state).and_return(state_mock)
    mc = Scrooger::Machine.new('i-12345678')
    allow(mc).to receive(:instance).and_return(instance_mock)
    mc
  end

  shared_context 'when started' do
    let(:status_code) { 16 }
  end

  shared_context 'when stopped' do
    let(:status_code) { 80 }
  end

  describe '#started?' do
    subject { mc.started? }

    context 'when a machine was started' do
      include_context 'when started'
      it { is_expected.to eq(true) }
    end

    context 'when a machine was stopped' do
      include_context 'when stopped'
      it { is_expected.to eq(false) }
    end
  end

  describe '#stopped?' do
    subject { mc.stopped? }

    context 'when a machine was started' do
      include_context 'when started'
      it { is_expected.to eq(false) }
    end

    context 'when a machine was stopped' do
      include_context 'when stopped'
      it { is_expected.to eq(true) }
    end
  end
end
