module tuple_operation;

import std.typecons;
import std.traits;

auto tupleAccumlate(Func,First,Types...)(Func func,First first,Types args){
    static if(args.length > 0){
        return tupleAccumlate(func,func(first,args[0]),args[1..$]);
    }
    else{
        return first;
    }
}

struct FilterFunctor(alias Pred){
    auto opCall(Tuple,T)(Tuple t,T value){
        static if(Pred!T){
            return tuple(t.expand,value);
        }
        else{
            return t;
        }
    }
}
auto tupleFilter(alias Pred,Types...)(Types args){
    return tupleAccumlate(
        FilterFunctor!Pred.init,
        tuple(),
        args
    );        
}

struct MapFunctor(alias Func){
	auto opCall(Tuple,T)(Tuple t,T value){
		return tuple(t.expand,Func(value));
	}
}
auto tupleMap(alias Func,Types...)(Types args){
	return tupleAccumlate(
		MapFunctor!Func.init,
		tuple(),
		args
	);
}

