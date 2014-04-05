import named_parameter;

import std.stdio;

void func(int hage,string hige){
	writeln(hage,',',hige);
}

void main(){
	auto neofunc = make_named_parameter_caller!func;
	neofunc(100,"kawaii","kawasaki".passAs!"hige");
}

