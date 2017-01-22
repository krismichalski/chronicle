#include "stdafx.h"
#include "all.h"

Assert::Assert()
{
}

bool Assert::AreEqual(std::string value1, std::string value2)
{
	if(value1 == value2) return true;
	else return false;
}