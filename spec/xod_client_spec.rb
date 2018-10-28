require 'spec_helper'

RSpec.describe XodClient do
  it 'has a version number' do
    expect(XodClient::VERSION).not_to be nil
  end

  let(:relying_party) { 'relying-party.com' }
  let(:estab) { '3281101' }
  let(:secret) { 'secret' }
  let(:token) { IO.read("#{__dir__}/fixtures/token.txt").chomp }
  let(:raw_token_expires_at) { '2018-06-24T18:55:26.1852229Z' }
  let(:token_expires_at) { Time.iso8601(raw_token_expires_at) }
  let(:client) { XodClient.init(relying_party, estab, secret, token: token, token_expires_at: token_expires_at) }

  around do |example|
    travel_to(Time.parse('19 Jun 2018'), &example)
  end

  context 'initialized without token information' do
    let(:client) { XodClient.init(relying_party, estab, secret) }

    it 'requests a token and remembers it' do
      VCR.use_cassette('valid_token') do
        client.ensure_token
      end

      expect(client.token).to eq(token)
      expect(client.token_expires_at).to eq(token_expires_at)
    end
  end

  it 'fails loudly on response error' do
    VCR.use_cassette('error_response') do
      expect { client.token_details.fetch }.to raise_error(XodClient::ResponseError)
    end
  end

  it 'fetches token details' do
    VCR.use_cassette('token_details') do
      json = client.token_details.fetch

      expect(json[:estab]).to eq(estab)
      expect(json[:expires]).to eq(raw_token_expires_at)
      expect(json[:name]).to eq('Dev SMHW (unverified)')
      expect(json[:relying_party]).to eq('relying-party.com')
      expect(json[:scopes]).to match_array(%w(
        Address
        AgencyAgent
        AssessmentResults
        Attendance
        Conduct
        ConductComments
        Contact
        EndpointInfo
        Photos
        School
        SEN
        SENTypes
        Staff
        StaffAbsence
        StaffAddress
        StaffContractual
        StaffEmployment
        StaffEthnicity
        StaffExtended
        StaffPersonalContact
        StaffReligion
        Student
        StudentDemographic
        StudentEthnicity
        StudentExclusions
        StudentExtended
        StudentFamily
        StudentFreeText
        StudentFunding
        StudentMedical
        StudentPregnancy
        StudentReligion
        StudentSchoolHistory
        WritebackAssessment
        WritebackAttendance
        WritebackConduct
      ))
    end
  end

  it 'fetches scopes' do
    VCR.use_cassette('scopes') do
      json = client.scopes.fetch

      expect(json[:scopes].many?).to eq(true)
      expect(json[:scopes].first).to eq(
        name: 'Address',
        category: 'Students',
        description: 'Access to addresses for authorised person types (Students / Contacts)'
      )
    end
  end

  it 'fetches allowed queries' do
    VCR.use_cassette('queries') do
      json = client.queries.fetch

      expect(json[:endpoints].many?).to eq(true)
      first_endpoint = json[:endpoints].first
      expect(first_endpoint[:version]).to eq('1')
      expect(first_endpoint[:id]).to eq('POST.Attendance')
      expect(first_endpoint[:method]).to eq('POST')
      expect(first_endpoint[:scope]).to eq('WritebackAttendance')
      expect(first_endpoint[:path]).to eq('/api/v1/Attendance/{estab}/')
      expect(first_endpoint[:description]).to be
      expect(first_endpoint[:documentation]).to be
      expect(first_endpoint[:documentation]).to be
      expect(first_endpoint[:query]).to eq('')
      expect(first_endpoint[:options]).to eq('')
      expect(first_endpoint[:parameters]).to eq('')
      expect(first_endpoint[:published]).to eq(true)
      expect(first_endpoint[:page_size]).to eq(0)
    end
  end

  it 'fetches logs' do
    VCR.use_cassette('logs') do
      expect { client.logs(take: 100).fetch }.not_to raise_error
    end
  end

  it 'fetches usage' do
    VCR.use_cassette('usage') do
      expect { client.usage.fetch }.not_to raise_error
    end
  end

  it 'fetches gdpr ids' do
    VCR.use_cassette('gdpr_ids') do
      expect { client.gdpr_ids.fetch }.not_to raise_error
    end
  end

  it 'fetches students first page' do
    VCR.use_cassette('students') do
      json = client.students(page_size: 2).fetch
      expect(json[:students].many?).to eq(true)
      student = json[:students].first
      expect(student[:id]).to eq('3116')
      expect(student[:xid]).to eq('xUYWRO2')
      expect(student[:external_id]).to eq('05a289a1-d579-4285-b050-894f5e11e04a')
      expect(student[:idaas_id]).to eq('PL-3116')
      expect(student[:forename]).to eq('Albus')
      expect(student[:surname]).to eq('Dumbledore')
      expect(student[:display_name]).to eq('Albus Dumbledore')
      expect(student[:admission_no]).to eq('001275')
      expect(student[:gender]).to eq('M')
      expect(student[:reg_group_id]).to eq('188')
      expect(student[:reg_group]).to eq('4ES')
      expect(student[:year_group_id]).to eq('28')
      expect(student[:year_group]).to eq('Year  4')
      expect(student[:house_group_id]).to eq(nil)
      expect(student[:house_group]).to eq(nil)
      expect(student[:work_email]).to eq(nil)
      expect(student[:idaas_email]).to eq(nil)
      expect(student[:dateof_birth]).to eq('2009-01-12')
      expect(student[:unique_learner_number]).to eq(nil)
      expect(student[:middle_name]).to eq(nil)
      expect(student[:enrolment_status]).to eq('C')
      expect(student[:boarder]).to eq(1)
      expect(student[:legal_forename]).to eq('Albus')
      expect(student[:legal_surname]).to eq('Dumbledore')
      expect(student[:entry_date]).to eq('2012-09-01')
      expect(student[:leaving_date]).to eq(nil)
      expect(student[:destination]).to eq(nil)
      expect(student[:destination_start_date]).to eq(nil)
      expect(student[:reason_for_leaving]).to eq(nil)
      expect(student[:sen_provision]).to eq('K')
      expect(student[:fsm_eligible]).to eq(0)
      expect(student[:fsm_end_date]).to eq(nil)
      expect(student[:uniform_allowance]).to eq(0)
      expect(student[:pupil_premium]).to eq(0)
      expect(student[:yssa]).to eq(nil)
      expect(student[:eal]).to eq(1)
      expect(student[:fsm_ever6]).to eq(0)
      expect(student[:gifted]).to eq(0)
      expect(student[:service_child]).to eq('0')
      expect(student[:service_child_source]).to eq(nil)
      expect(student[:in_lea_care]).to eq(0)
      expect(student[:lea_care_authority]).to eq(nil)
      expect(student[:ever_in_care]).to eq(0)
      expect(student[:is_young_carer]).to eq(0)
      expect(student[:asylum_status]).to eq(nil)
      expect(student[:religion_code]).to eq('MU')
      expect(student[:religion]).to eq('Muslim')
      expect(student[:ethnicity_code]).to eq('ABAN')
      expect(student[:ethnicity]).to eq('Bangladeshi')
      expect(student[:ethnicity_source]).to eq('P')
      expect(student[:home_language]).to eq(nil)
      expect(student[:home_language_code]).to eq(nil)
      expect(student[:first_language]).to eq('English')
      expect(student[:first_language_code]).to eq('ENG')
      expect(student[:first_language_source]).to eq('S')
      expect(student[:english_proficiency_level]).to eq('Competent')
      expect(student[:national_identity]).to eq('Other')
      expect(student[:nationality]).to eq('United Kingdom')
      expect(student[:mode_of_travel]).to eq('Car Share (with child/children)')
      expect(student[:is_traveller]).to eq(0)
      expect(student[:traveller_source]).to eq(nil)
      expect(student[:parental_salutation]).to eq('Mr and Mrs Dumbledore')
      expect(student[:address_block]).to eq("3 Penrith Grove\nPeterborough\nPE4 7FQ\nUnited Kingdom")
      expect(student[:house_no]).to eq('3')
      expect(student[:house_name]).to eq(nil)
      expect(student[:apartment]).to eq(nil)
      expect(student[:street]).to eq('Penrith Grove')
      expect(student[:district]).to eq(nil)
      expect(student[:town_or_city]).to eq('Peterborough')
      expect(student[:county]).to eq(nil)
      expect(student[:post_code]).to eq('PE4 7FQ')
      expect(student[:country]).to eq('United Kingdom')
      expect(student[:student_status]).to eq('OnRoll')
      expect(student[:quick_note]).to eq(nil)
      expect(student[:last_updated]).to eq('2018-06-12T02:07:21.03')
      expect(student[:row_hash]).to eq('D33933841636DA3C985B7F24263572B445ECE329')
    end
  end

  it 'fetches students second page' do
    VCR.use_cassette('students') do
      json = client.students(page: 2, page_size: 2).fetch
      expect(json[:students].many?).to eq(true)
    end
  end

  it 'fetches all students with each fetcher' do
    VCR.use_cassette('students') do
      arr = []
      client.students(page_size: 2).each do |json|
        arr << json[:id]
      end
      expect(arr).to match_array(%w(3116 3217 3221 3920))
    end
  end

  it 'fetches a particular student' do
    VCR.use_cassette('student') do
      student = client.students(id: '3116').first
      expect(student[:id]).to eq('3116')
      expect(student[:display_name]).to eq('Albus Dumbledore')
    end
  end

  it 'fetches school info' do
    VCR.use_cassette('school_info') do
      school_info = client.school_info.first
      expect(school_info[:id]).to eq('1')
      expect(school_info[:name]).to eq('WATERS EDGE PRIMARY SCHOOL')
      expect(school_info[:head]).to eq('Gillian Grosvenor')
      expect(school_info[:main_contact]).to eq('Mrs G Grosvenor')
      expect(school_info[:telephone]).to eq('852015')
      expect(school_info[:web]).to eq(nil)
      expect(school_info[:email]).to eq('school@we.com')
      expect(school_info[:deni_no]).to eq('823PSCO2999')
      expect(school_info[:governance]).to eq('Community')
      expect(school_info[:phase]).to eq('Primary')
      expect(school_info[:exam_centre]).to eq(nil)
      expect(school_info[:address]).to be
      expect(school_info[:estab_id]).to eq('8232999')
      expect(school_info[:current_academic_year]).to eq('2017')
      expect(school_info[:last_updated]).to eq('2017-01-20T03:05:20.755')
      expect(school_info[:row_hash]).to eq('42B44300B8B026D752CADE239AF214085236A542')
    end
  end

  it 'fetches groups' do
    VCR.use_cassette('groups') do
      group = client.groups(page_size: 2).first
      expect(group[:id]).to eq('31')
      expect(group[:xid]).to eq('xL8TTH2')
      expect(group[:external_id]).to eq('013e06d4-aa20-4b70-841d-e72767a7f744')
      expect(group[:idaas_id]).to eq('GY-31')
      expect(group[:type]).to eq('YearGrp')
      expect(group[:code]).to eq('1')
      expect(group[:name]).to eq('Year  1')
      expect(group[:primary_staff_id]).to eq(nil)
      expect(group[:staff]).to eq(nil)
      expect(group[:num_students]).to eq(59)
      expect(group[:row_hash]).to eq('078C01F95CFE89EE7A3D972C8AF2EA86017F51CA')
      expect(group[:last_updated]).to eq('2017-12-20T01:38:21.48')
    end
  end

  it 'fetches staff' do
    VCR.use_cassette('staff') do
      expect { client.staff(page_size: 2).fetch }.not_to raise_error
    end
  end

  it 'fetches timetable' do
    VCR.use_cassette('timetable') do
      expect { client.timetable.fetch }.not_to raise_error
    end
  end

  it 'fetches timetable model' do
    VCR.use_cassette('timetable_model') do
      expect { client.timetable_model.fetch }.not_to raise_error
    end
  end

  it 'fetches timetable structure' do
    VCR.use_cassette('timetable_structure') do
      expect { client.timetable_structure.fetch }.not_to raise_error
    end
  end

end
