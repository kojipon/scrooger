# frozen_string_literal: true

require_relative '../lib/scrooger/calendar'

RSpec.describe 'Scrooger::Calendar' do
  let(:cal) do
    items_mock = instance_double('Google::Apis::CalendarV3::Events')
    allow(items_mock).to receive(:items).and_return(resources)
    api_mock = instance_double('Google::Apis::CalendarV3::CalendarService')
    allow(api_mock).to receive(:list_events).and_return(items_mock)
    config = { 'credential_path' => 'config.yml.sample' }
    cal = Scrooger::Calendar.new('123456', { config: config })
    allow(cal).to receive(:api).and_return(api_mock)
    cal
  end

  shared_context 'when reserved' do
    let(:resources) { ['reserved'] }
  end

  shared_context 'when released' do
    let(:resources) { [] }
  end

  describe '#calendar_id' do
    subject { cal.calendar_id }

    context 'when reserved a machine on the calendar' do
      include_context 'when reserved'
      it { is_expected.to eq('123456') }
    end
  end

  describe '#released?' do
    subject { cal.released? }

    context 'when reserved a machine on the calendar' do
      include_context 'when reserved'
      it { is_expected.to eq(false) }
    end

    context 'when released a machine on the calendar' do
      include_context 'when released'
      it { is_expected.to eq(true) }
    end
  end

  describe '#reserved?' do
    subject { cal.reserved? }

    context 'when reserved a machine on the calendar' do
      include_context 'when reserved'
      it { is_expected.to eq(true) }
    end

    context 'when released a machine on the calendar' do
      include_context 'when released'
      it { is_expected.to eq(false) }
    end
  end
end
