#ifndef _H_PERSON_KM
#define _H_PERSON_KM

#include <iostream>
#include <list>
#include <string>
#include <regex>
#include <fstream>
#include <sstream>
#include <iomanip>

using namespace std;

class Person
{
public:
  Person(int _id);
  Person(istream& _id);
  ~Person(void);
  bool operator==(const Person& person) const;
  int getID(void) const;
  string getName(void) const;
  string getBirthyear(void) const;
  string getPesel(void) const;
  void setName(istream& _name);
  void setBirthyear(istream& _birthyear);
  void setPesel(istream& _pesel);
private:
  int id;
  string name;
  string birthyear;
  string pesel;
  bool nameValidator(void);
  bool birthyearValidator(void);
  bool peselValidator(void);
};

#endif //_H_PERSON_KM
