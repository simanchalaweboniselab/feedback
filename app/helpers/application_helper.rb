module ApplicationHelper
  def user_name(id)
    User.find(id).name
  end

  def date(date)
    date = date.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
    date.strftime("%a, %d-%b-%Y, %I:%M:%p")
  end
end
