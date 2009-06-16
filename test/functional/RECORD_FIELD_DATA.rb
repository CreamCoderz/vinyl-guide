module RECORD_FIELD_DATA
  RECORD_DISPLAY_FIELDS = ['artist', 'name', 'description', 'date', 'img_src', 'producer', 'band', 'engineer', 'studio']

  RECORD_INPUT_TYPE_FIELDS = Array.new(RECORD_DISPLAY_FIELDS);
  RECORD_INPUT_TYPE_FIELDS.delete('date')

  RECORD_SEARCHABLE_FIELDS = Array.new('artist', 'name', 'description', 'producer', 'band', 'engineer', 'studio');

end