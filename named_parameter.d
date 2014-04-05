module named_parameter;

import tuple_operation;
import typecons;

import std.string;
import std.traits;
import std.typecons;
import std.typetuple;

struct PassAs(string identifier,T){
	T value;
	this(T v){
		value = v;
	}
}
auto passAs(string identifier,T)(T value){
	return PassAs!(identifier,T)(value);
}
struct PassAt(size_t Index,T){
	enum index = Index;
	T value;
	this(T v){
		value = v;
	}
}
auto passAt(size_t Index,T)(T value){
	return PassAt!(Index,T)(value);
}

template IsPassAs(T){
	enum IsPassAs = false;
}
template IsPassAs(T : PassAs!(Identifier,T), string Identifier){
	enum IsPassAs = true;
}

auto applyPassAt(PassAtTuple,Args...)(PassAtTuple pas,ref Args args){
	foreach(pa;pas.expand){
		args[pa.index] = pa.value;
	}
}

struct PassAsToPassAt(alias Func){
	auto opCall(T,string identifier)(PassAs!(identifier,T) pa){
		return passAt!(function_traits!Func.identifier_number!identifier)(pa.value);
	}
}

struct NamedParameterCaller(alias Func){
	auto build_params_tuple(Args...)(Args args){
		alias ArgumentTypes = ParameterTypeTuple!Func;
		alias Types = TypeTuple!Args;
		alias NamedParameters = Filter!(IsPassAs,Types);
		alias UnnamedParameters = Filter!(templateNot!IsPassAs,Types);
		
		ArgumentTypes arguments_tuple;
		auto not_pass_as = tupleFilter!(templateNot!IsPassAs)(args);
		arguments_tuple[0..not_pass_as.length] = not_pass_as[0..$];
		
		auto pass_as = tupleFilter!IsPassAs(args);
		auto pass_at = tupleMap!(PassAsToPassAt!Func.init)(pass_as.expand);
		applyPassAt(pass_at,arguments_tuple);
		return tuple(arguments_tuple);
	}

	auto opCall(Args...)(Args args){
		Func(build_params_tuple(args).expand);
	}
}

auto make_named_parameter_caller(alias Func)(){
	return NamedParameterCaller!Func.init;
}
