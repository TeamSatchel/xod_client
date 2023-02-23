module XodClient
  module DataEndpoints
    # COMMON_PARAMS: estab, updated_since, page, page_size, changed_rows, select, callback_url

    # params: options, id, type, code, COMMON_PARAMS
    # options: includeStaffMembers
    #          includeStudentMembers
    #          includeMembersIds
    #          includeMembersIdaasIds
    #          includeMembersXIDs
    #          includeSubjects
    #          includeGroupTypes
    # type: YearGrp, HouseGrp, RegGrp, TeachingGrp
    def groups(**params)
      endpoint('school.groups', **params)
    end

    def health(**params)
      endpoint('school.health', **params)
    end

    # params: COMMON_PARAMS
    def school_info(**params)
      endpoint('school.schoolinfo', **params)
    end

    # params: id, staff_status, COMMON_PARAMS
    # options: includePhotos
    #          includeGroupIds
    #          includeGroupIdaasIds
    #          includeGroupXIDs
    #          teachersOnly
    #          includeFuture
    #          includePrevious
    # staff_status: Current, Future, Previous
    def staff(**params)
      endpoint('school.staff', **params)
    end

    # params: options, id, year_group_id, student_status, onlygetDBStatus, COMMON_PARAMS
    # options: includePhotos
    #          includeGroupIds
    #          includeGroupIdaasIds
    #          includeGroupXIDs
    #          includeParentIdaasIds
    #          includeParentXIDs
    #          includeAttStats
    #          includeAttMarkString
    #          includeSiblingsList
    #          includeSiblingsResultset
    #          includeLeavers
    #          includePreAdmissions
    #          includeGuests
    #          includeSubsidiary
    def students(**params)
      endpoint('school.students', **params)
    end

    # params: options, date_from, date_to, COMMON_PARAMS
    # options: includeLessons
    #          includeLessonStaff
    #          includeLessonRooms
    def timetable(**params)
      endpoint('school.timetable', **params)
    end

    # params: COMMON_PARAMS
    def timetable_model(**params)
      endpoint('school.timetablemodel', **params)
    end

    # params: date_from, date_to, COMMON_PARAMS
    def timetable_structure(**params)
      endpoint('school.timetablestructure', **params)
    end

  end
end
