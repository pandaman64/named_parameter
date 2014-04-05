module typecons;

import std.algorithm;
import std.traits;

template function_traits(Func...){
	bool has_identifier(string identifier)(){
		return identifier_number!identifier != -1;
	}
	bool has_nth_parameter(size_t index)(){
		return arity!Func > index;
	}
	string nth_identifier(size_t index)(){
		return ParameterIdentifierTuple!Func[index];
	}
	auto identifier_number(string identifier)(){
		return [ParameterIdentifierTuple!Func].countUntil(identifier);
	}
}


