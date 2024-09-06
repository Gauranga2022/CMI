#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
List enlist(CharacterVector y) {
            List lis;
            
            CharacterVector::iterator n = y.end();
            CharacterVector::iterator i;
            for (i = y.begin();i < n; ++i){
                        String j = *i;
                        lis[j] = j;
            }
            return lis;
}






