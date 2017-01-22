#include "stdafx.h"
#include "all.h"

ShortScale::ShortScale(std::string _symbol)
{
	symbol = _symbol;
}

std::string ShortScale::Expand()
{
	// smatch is for std::string
	// cmatch is for char[]
	std::smatch regex_results;
	std::regex_match(symbol, regex_results, std::regex("^([1-9])([0-9]{0,2})(\\.(([0-9]{1,3})?))?(M|B|T|Qa|Qi|Sx|Sp|Oc)$"));

	// check data format
	if(regex_results.size() == 0) return "Error! Incorrect data format!";

	// deal with numbers after comma
	std::string first_zeros = " ";
	first_zeros += regex_results[4].str();
	for(unsigned int i = 3; i > regex_results[4].str().length(); --i) first_zeros += "0"; // add missing zeros (unsigned int for warning supressing)

	// map symbols to correct number of zeros
	std::string symbols[8] = {"M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc"}; // order matters
	std::map<std::string, std::string> short_scale;
	for(int i = 0; i < 8; ++i)
	{
		std::string zeros = first_zeros;
		for(int j = 0; j <= i; ++j) zeros += " 000";
		short_scale[symbols[i]] = zeros;
	}

	// join two firts chunks (first number cannot be zero)
	std::string number_part = regex_results[1].str() + regex_results[2].str();

	// get symbol alone
	std::string symbol_part = regex_results[regex_results.size() - 1];

	// return number with zeros
	return number_part + short_scale[symbol_part];
}