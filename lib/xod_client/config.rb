module XodClient
  class Config

    def login_url
      'https://login.groupcall.com/idaas/sts/STS/GetToken'
    end

    def root_url
      'https://xporter.groupcall.com'
    end

    def retry_options
      { max: 2, interval: 0.25.seconds, backoff_factor: 2, retry_statuses: [500, 502, 503] }
    end

    def user_agent
      'TeamSatchel XoD Client'
    end

    # rubocop:disable MethodLength
    def endpoints
      @endpoints ||= {
        token_details:                           '/api/v1/TokenDetails',
        queries:                                 '/api/v1/Queries',
        scopes:                                  '/api/v1/Scopes',
        logs:                                    '/api/v1/TokenDetails',
        usage:                                   '/api/v1/Usage',
        gdpr_ids:                                '/api/v1/GDPRIDs',
        'edubase.search'                      => '/api/v1/RunQuery/?id=edubase.search',
        'school.achievementfordaterange'      => '/api/v1/School/{estab}/AchievementForDateRange/{id}',
        'school.achievementfortoday'          => '/api/v1/School/{estab}/AchievementForToday/{id}',
        'school.agencyagent'                  => '/api/v1/School/{estab}/AgencyAgent/',
        'school.assessmentresults'            => '/api/v1/School/{estab}/assessmentresults/',
        'school.assessmentresultsbyaspect'    => '/api/v1/School/{estab}/assessmentresults/',
        'school.assessmentresultsbymarksheet' => '/api/v1/School/{estab}/assessmentresults/',
        'school.assessmentresultsbystudent'   => '/api/v1/School/{estab}/assessmentresults/',
        'school.assessmentstructure'          => '/api/v1/School/{estab}/assessmentstructure/',
        'school.attendancecodes'              => '/api/v1/School/{estab}/AttendanceCodes/{id}',
        'school.attendancefordate'            => '/api/v1/School/{estab}/AttendanceForDate/{id}',
        'school.attendancefordaterange'       => '/api/v1/School/{estab}/AttendanceForDateRange/{id}',
        'school.behaviourfordaterange'        => '/api/v1/School/{estab}/BehaviourForDateRange/{id}',
        'school.behaviourfortoday'            => '/api/v1/School/{estab}/BehaviourForToday/{id}',
        'school.calendar'                     => '/api/v1/School/{estab}/Calendar/{id}',
        'school.conductfordaterange'          => '/api/v1/School/{estab}/ConductForDateRange/{id}',
        'school.conductfortoday'              => '/api/v1/School/{estab}/ConductForToday/{id}',
        'school.conductlookups'               => '/api/v1/School/{estab}/conductlookups/',
        'school.conductpoints'                => '/api/v1/School/{estab}/ConductPoints/{id}',
        'school.contacts'                     => '/api/v1/School/{estab}/Contacts/{id}',
        'school.counts'                       => '/api/v1/School/{estab}/Counts',
        'school.entitlementhistory'           => '/api/v1/School/{estab}/EntitlementHistory/{id}',
        'school.groups'                       => '/api/v1/School/{estab}/Groups/{id}',
        'school.health'                       => '/api/v1/School/{estab}/Health',
        'school.linkeddocuments'              => '/api/v1/School/{estab}/LinkedDocuments',
        'school.linkeddocumenttypes'          => '/api/v1/School/{estab}/LinkedDocumentTypes',
        'school.personcomms'                  => '/api/v1/School/{estab}/PersonComms/{id}',
        'school.photos'                       => '/api/v1/School/{estab}/Photos/{id}',
        'school.schoolinfo'                   => '/api/v1/School/{estab}/SchoolInfo',
        'school.seatingplans'                 => '/api/v1/School/{estab}/SeatingPlans',
        'school.sen'                          => '/api/v1/School/{estab}/SEN/{id}',
        'school.staff'                        => '/api/v1/School/{estab}/Staff/{id}',
        'school.staffabsence'                 => '/api/v1/School/{estab}/StaffAbsence/{id}',
        'school.staffcontracts'               => '/api/v1/School/{estab}/StaffContracts',
        'school.studentcontacts'              => '/api/v1/School/{estab}/StudentContacts/{id}',
        'school.studentexclusions'            => '/api/v1/School/{estab}/StudentExclusions/{id}',
        'school.studentmeals'                 => '/api/v1/School/{estab}/StudentMeals/{id}',
        'school.studentmedical'               => '/api/v1/School/{estab}/StudentMedical/{id}',
        'school.students'                     => '/api/v1/School/{estab}/Students/{id}',
        'school.studentschoolhistory'         => '/api/v1/School/{estab}/StudentSchoolHistory/{id}',
        'school.studentuserdefinedfields'     => '/api/v1/School/{estab}/studentuserdefinedfields/{id}',
        'school.timetable'                    => '/api/v1/School/{estab}/Timetable/',
        'school.timetableforstaff'            => '/api/v1/School/{estab}/TimetableForStaff/{id}',
        'school.timetableforstudent'          => '/api/v1/School/{estab}/TimetableForStudent/{id}',
        'school.timetablemodel'               => '/api/v1/School/{estab}/TimetableModel',
        'school.timetablestructure'           => '/api/v1/School/{estab}/TimetableStructure',
        'school.userdefinedfields'            => '/api/v1/School/{estab}/UserDefinedFields/{id}',
        'POST.Attendance'                     => '/api/v1/Attendance/{estab}/',
        'POST.AttendanceAsync'                => '/api/v1/AttendanceAsync/{estab}/',
        'POST.ConductAch'                     => '/api/v1/Writeback/Conduct',
        'POST.ConductAsync'                   => '/api/v1/Writeback/ConductAsync',
        'POST.ConductBeh'                     => '/api/v1/Writeback/Conduct',
        'POST.LessonAttendance'               => '/api/v1/Attendance/{estab}/',
        'POST.SeatingPlan'                    => '/api/v1/Writeback/SeatingPlan',
        'POST.efw.Detention'                  => '/api/v1/Writeback/?id=efw.Detention',
      }.with_indifferent_access
    end

  end
end
