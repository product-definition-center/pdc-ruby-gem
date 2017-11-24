require 'spec_helper'

describe PDC::V1::GlobalComponentContact do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:contact) { PDC::V1::GlobalComponentContact }

  it 'must has compose' do
    contact.where(component: 'vlgothic-fonts').first.contact.must_be_instance_of OpenStruct
  end

  describe 'count' do
    it 'must return number of resources' do
      count = contact.count
      count.must_equal 12546
    end

    it 'works with where' do
      count = contact.where(component: 'vlgothic-fonts').count
      count.must_equal 3 # as there is 3 fields per entry
    end

    it 'can find global contact by component name' do
      count = contact.where(component: 'vlgothic-fonts').count
      count.must_equal 3
    end
  end

  describe '#contact' do
    it 'returns contact for component' do
      vf = contact.where(component: 'vlgothic-fonts').first
      vf.contact.wont_be_nil
    end

    it 'returns a contact email' do
      vf = contact.where(component: 'vlgothic-fonts').first
      vf.contact.email.must_equal 'qe-i18n-bugs@redhat.com'
    end

    it 'returns a mail_name' do
      vf = contact.where(component: 'vlgothic-fonts').first
      vf.contact.mail_name.must_equal 'I18N'
    end

    it 'returns a gloabl contact id' do
      vf = contact.where(component: 'vlgothic-fonts').first
      vf.contact.id.must_equal 5
    end
  end

  describe '#role' do
    it 'returns contact role' do
      bash_contact = contact.where(component: 'bash').first
      bash_contact.role.wont_be_nil
      bash_contact.role.must_equal 'QE_Group'
    end
  end
end
