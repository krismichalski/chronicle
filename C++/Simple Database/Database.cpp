#include "Database.h"
#include "sort_methods.h"

Database::Database(void)
{
  this->lastID = 0;
}

Database::~Database(void)
{
}

void Database::print(ostream& output, int mode = 0)
{
  if(this->empty())
  {
    if(mode == 0) output << "Database is empty";
  }
  else
  {
    if(mode == 0) output << "ID" << "\t" << "Year" << "\t" << "PESEL" << "\t\t" << "Name" << "\t" << endl << endl;
    for(it = this->begin(); it != this->end(); ++it)
    {
      if(mode == 0) output << it->getID() << "\t";
      output << it->getBirthyear() << "\t" << it->getPesel() << "\t" << it->getName() << endl;
    }
  }
  if(mode == 0) output << endl << endl;
}

int Database::nextID()
{
  return this->lastID += 1;
}

void Database::addPerson(void)
{
  this->emplace_back(Person(this->nextID()));
  cout << "Name: ";
  this->back().setName(cin);
  cout << "Year of birth: ";
  this->back().setBirthyear(cin);
  cout << "PESEL: ";
  this->back().setPesel(cin);
}

void Database::removePerson(void)
{
  cout << "ID: ";
  this->remove(Person(cin));
}

void Database::sortMenu(void)
{
  int sort_method;
  cout << "Sort methods: " << endl
       << "1) By name" << endl
       << "2) By year of birth" << endl
       << "3) By birthday" << endl
       << "Which one: ";

  cin >> sort_method;

  switch(sort_method)
  {
    case 1:
      this->sort(compare_name_nocase);
      break;
    case 2:
      this->sort(compare_birthyear);
      break;
    case 3:
      this->sort(compare_birthday);
      break;
    default:
      cout << "No such option!\n";
      break;
  }
}

void Database::saveToFile(void)
{
  ofstream file;
  string filename;

  cout << "Filename: ";
  cin >> filename;
  file.open(filename);
  if(file.is_open())
  {
    print(file, 1); // print for file saving
    file.close();
    cout << "Success." << endl;
  }
  else
  {
    cout << "Could not open file." << endl;
  }
}

void Database::readFromFile(void)
{
  ifstream file;
  string filename, line, token;

  cout << "Filename: ";
  cin >> filename;

  file.open(filename);

  if(file.is_open())
  {
    this->clear();
    while(getline(file, line))
    {
      this->emplace_back(Person(this->nextID()));

      istringstream line_iss(line);

      getline(line_iss, token, '\t');
      istringstream birthyear_token_iss(token);
      this->back().setBirthyear(birthyear_token_iss);

      getline(line_iss, token, '\t');
      istringstream pesel_token_iss(token);
      this->back().setPesel(pesel_token_iss);

      getline(line_iss, token, '\t');
      istringstream name_token_iss(token);
      this->back().setName(name_token_iss);
    }
    file.close();
    cout << "Success." << endl;
  }
  else
  {
    cout << "Could not open file." << endl;
  }
}

