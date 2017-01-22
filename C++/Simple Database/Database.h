#ifndef _H_DATABASE_KM
#define _H_DATABASE_KM

#include "Person.h"

class Database : public list<Person>
{
public:
  Database(void);
  ~Database(void);
  void print(ostream& output, int mode);
  void addPerson(void);
  void removePerson(void);
  void sortMenu(void);
  void saveToFile(void);
  void readFromFile(void);
private:
  list<Person>::iterator it;
  int lastID;
  int nextID();
};

#endif //_H_DATABASE_KM
