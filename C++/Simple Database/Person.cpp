#include "Person.h"

Person::Person(int _id)
{
  this->id = _id;
  this->name = "";
  this->birthyear = "";
  this->pesel = "";
}

Person::Person(istream& _id)
{
  _id >> this->id;
  if(_id.fail())
  {
    // user didn't input a number
    cout << "Not a number. Try again: ";
    cin.clear(); // reset failbit
    cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); //skip bad input
    cin >> this->id;
  }
  Person(this->id);
}

Person::~Person(void)
{
}

bool Person::operator==(const Person& person) const
{
  return (person.getID() == this->getID());
}

int Person::getID(void) const
{
  return id;
}

string Person::getName(void) const
{
  return name;
}

string Person::getBirthyear(void) const
{
  return birthyear;
}

string Person::getPesel(void) const
{
  return pesel;
}

void Person::setName(istream& _name)
{
  _name >> name;
  if(nameValidator())
  {
    cout << "Incorrect name. Try again: ";
    setName(cin);
  }
}

void Person::setBirthyear(istream& _birthyear)
{
  _birthyear >> birthyear;
  if(birthyearValidator())
  {
    cout << "Incorrect year of birth. Try again: ";
    setBirthyear(cin);
  }
}

void Person::setPesel(istream& _pesel)
{
  _pesel >> pesel;
  if(peselValidator())
  {
    cout << "Incorrect PESEL. Try again: ";
    setPesel(cin);
  }
}

bool Person::nameValidator(void)
{
  return !regex_match(name, regex("^[A-Za-z]+$"));
}

bool Person::birthyearValidator(void)
{
  return !regex_match(birthyear, regex("^(1979|19[8-9][0-9]|20[0-1][0-9])$"));
}

bool Person::peselValidator(void)
{
  return !regex_match(pesel, regex("^[0-9]{4}[0-3]{1}[0-9]{1}[0-9]{5}$"));
}
