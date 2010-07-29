module ReleasesHelper
  def release_title_for(release)
    display_fields = [] << release.title << release.artist << release.year << release.matrix_number << (release.format.name if release.format) << (release.label_entity.name if release.label_entity)
    display_fields.select{|value| !value.blank?}.join(" - ")
  end
end
