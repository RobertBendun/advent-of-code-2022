#include <fstream>
#include <iostream>
#include <iterator>
#include <string_view>
#include <unordered_set>

int main()
{
	std::ifstream input_file("input.txt");
	std::string input{std::istreambuf_iterator<char>(input_file), {}};

	for (auto length : {/*part1*/4, /*part2*/14}) {
		for (auto it = input.begin(); it+length < input.end(); it++) {
			if (std::unordered_set<char> chars{it, it+length}; chars.size() == length) {
				std::cout << (std::distance(input.begin(), it)+length) << '\n';
				break;
			}
		}
	}
}

