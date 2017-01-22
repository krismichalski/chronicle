class Assert
{
public:
	Assert();
	bool AreEqual(std::string, std::string); //TODO: make it universal (for int, float, etc.)
private:
	std::string value1;
	std::string value2;
};