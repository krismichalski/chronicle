#include "Database.h"
#include <cstdlib>

int main(int argc, char const *argv[])
{
  bool run = true;
  int menu = 0;
  Database db = Database();

  while(run)
  {
    if(system("CLS")) system("clear");
    db.print(cout, 0);

    cout  << "Menu:\n\n"
          << "1. Add person\n"
          << "2. Remove person\n"
          << "3. Sort database\n"
          << "4. Save database\n"
          << "5. Load database\n"
          << "0. Exit\n";
    cout << "Which one: ";
    cin >> menu;

    switch(menu)
    {
      case 1:
        db.addPerson();
        break;
      case 2:
        db.removePerson();
        break;
      case 3:
        db.sortMenu();
        break;
      case 4:
        db.saveToFile();
        break;
      case 5:
        db.readFromFile();
        break;
      case 0:
        run = false;
        break;
      default:
        cout << "No such option!\n";
        break;
    }
  }

  return 0;
}
