module Execute
  #execute sql query
  def execute_query sql
    ActiveRecord::Base.connection.execute(sql)
  end
end