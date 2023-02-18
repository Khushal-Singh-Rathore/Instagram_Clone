#include <iostream>
using namespace std;
class adding{
public:
int add(int a , int b){ return a+b;}
};
int main(){
    adding aa;
   cout<<  aa.add(4,5);
   
    return 0;
}