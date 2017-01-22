// comparison, not case sensitive.
bool compare_name_nocase(const Person& first, const Person& second)
{
  string first_name = first.getName();
  string second_name = second.getName();
  unsigned int i = 0;

  while((i < first_name.length()) && (i < second_name.length()))
  {
    if(tolower(first_name[i]) < tolower(second_name[i])) return true;
    else if(tolower(first_name[i]) > tolower(second_name[i])) return false;
    ++i;
  }
  return (first_name.length() < second_name.length());
}

bool compare_birthyear(const Person& first, const Person& second)
{
  int first_birthyear = stoi(first.getBirthyear());
  int second_birthyear = stoi(second.getBirthyear());

  if(first_birthyear > second_birthyear) return true;
  else if(first_birthyear < second_birthyear) return false;
  return true;
}

bool compare_birthday(const Person& first, const Person& second)
{
  string first_year = first.getPesel().substr(0, 2);
  int first_month = stoi(first.getPesel().substr(2, 2));
  string first_day = first.getPesel().substr(4, 2);

  string second_year = second.getPesel().substr(0, 2);
  int second_month = stoi(second.getPesel().substr(2, 2));
  string second_day = second.getPesel().substr(4, 2);

  if(first_year[0] == '0') first_year = "20" + first_year;
  else first_year = "19" + first_year;

  if(second_year[0] == '0') second_year = "20" + second_year;
  else second_year = "19" + second_year;

  if(first_month > 20) first_month -= 20;
  if(second_month > 20) second_month -= 20;

  stringstream first_date_stream("");
  stringstream second_date_stream("");

  first_date_stream << setw(2) << setfill('0') << first_month + 1 << "/";
  first_date_stream << first_day << "/";
  first_date_stream << first_year;

  second_date_stream << setw(2) << setfill('0') << second_month + 1 << "/";
  second_date_stream << second_day << "/";
  second_date_stream << second_year;

  struct tm first_date = {};
  struct tm second_date = {};

  first_date_stream >> get_time(&first_date, "%m / %d / %Y");
  second_date_stream >> get_time(&second_date, "%m / %d / %Y");

  time_t first_seconds = timegm(&first_date);
  time_t second_seconds = timegm(&second_date);

  if(first_seconds > second_seconds) return true;
  else if(first_seconds < second_seconds) return false;
  return true;
}
