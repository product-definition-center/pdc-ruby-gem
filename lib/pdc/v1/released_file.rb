module PDC
  module V1
    class ReleasedFile < PDC::Base
      attributes :id, :file_primary_key, :repo, :released_date,
                 :release_date, :created_at, :updated_at,
                 :zero_day_release, :obsolete, :build,
                 :package, :file
    end
  end
end
