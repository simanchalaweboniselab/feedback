module ApplicationHelper
  def user_name(users,id)
    #User.find(id).name
    user = users.to_a.select{|user| user.id == id}
    user[0][:name]
  end

  def username(id, users)
    user = users.to_a.select{|user| user.id == id}
    user[0][:name]
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
  def week_number(week)
    week = ((week.to_date.mjd - UserFeedback.first.created_at.to_date.mjd)/7)+2
    if (week >= 1)
      return "week-#{week}"
    end
  end
end
