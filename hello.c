#include<stdio.h>
#include<stdlib.h>
#include<math.h>

int main(){
    int x=500,y=4,z=2000;
    int time =0;
    int tokens = 0;
    int i;

    for(i=0;tokens<z;){
        int t = ceil((float)(x-tokens)/(2+y*i));

        int tk=(2+y*i)*t;
        if(tk+tokens>=z)break;
        int x = tk/500;
        // printf("x = %d\n",x);
        tokens+=tk-500*x;
        time+=t;
        i=i+x;
        printf("tokens = %d\n",tokens);
    }
        printf("time = %d\n",time);

    return 0;
}