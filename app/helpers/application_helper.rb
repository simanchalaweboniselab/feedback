module ApplicationHelper
  def user_name(id)
    User.find(id).name
  end

  def date(date)
    date = date.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
    date.strftime("%a, %d-%b-%Y, %I:%M:%p")
  end

  def user_to(user)
    users = user.from
    name = ""
    users.each do |u|
      name << "#{u.name} ,"
    end
  end
  def get_seconds(time)
    time = time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
    time = ((time.hour)*60*60)+((time.min)*60)+time.sec
  end
end
