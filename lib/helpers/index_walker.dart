/*
OPTIONAL CHAINING FOR MAP

For example you have - Map<String, dynamic> myMap = { 'firstFloor': { 'secondFloor': 'valueOfSecondFloor' } }
And you want to use optional chaining for it,
But you can't do like that - myMap?['firstFloor']?['secondFloor']
In this case you will get an error, there is no possibility to use optional chainig for Maps

But you can use this helper like that:
import 'package:FitLogger/helpers/index_walker.dart';
print(IndexWalker(myMap)['firstFloor']['secondFloor'].value); // valueOfSecondFloor
print(IndexWalker(myMap)['firstFloor']['anotherScondFloor'].value); // null
*/

class IndexWalker {
  dynamic value;
  IndexWalker(this.value);
  IndexWalker operator[](Object index) {
    if (value != null) value = value[index];
    return this;
  }
}