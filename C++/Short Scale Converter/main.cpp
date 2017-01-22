#include "stdafx.h"
#include "all.h"

int _tmain(int argc, _TCHAR* argv[])
{
	// user data
	std::string symbol;
	std::cout << "Pass symbolic notation (eg. 2M): ";
	getline(std::cin, symbol);

	ShortScale byUser(symbol);

	std::cout << "Your number: " << byUser.Expand() << std::endl << std::endl << "Other examples:" << std::endl;

	ShortScale TestA("4M");
	ShortScale TestB("54T");
	ShortScale TestC("5.43B");

	bool test1, test2, test3;

	test1 = Assert().AreEqual(TestA.Expand(), "4 000 000");
	test2 = Assert().AreEqual(TestB.Expand(), "54 000 000 000 000");
	test3 = Assert().AreEqual(TestC.Expand(), "5 430 000 000");

	if(test1) std::cout << TestA.Expand() << std::endl;
	if(test2) std::cout << TestB.Expand() << std::endl;
	if(test3) std::cout << TestC.Expand() << std::endl;

	system("pause");

	return 0;
}

