class QueryGenerator

  def self.generate_wild_query(fields, query_key)
    query = ''
    fields.each do |searchable_field|
      query += " OR " unless query.blank?
      query += "#{searchable_field} like #{query_key}"
    end
    return query
  end

end