#define MAX 1000
#include <stdio.h>

//int input[LENGTH] = {2,5,7,1,7,2,4,7,2,3};
//解は{1,2,4,7}で4
int input[MAX];
int answer[MAX];
int ansary[MAX];

//answerはi番目を最後とした部分列の最大長を格納する。
void initialize(int length){
  answer[0] = 1;
  for(int n = 1;n < length;n++){
    int ans = 0;
    for(int m = 1;m <= n;m++){
      if(input[n-m] < input[n] && ans < answer[n-m])ans = answer[n-m];
    }
    answer[n] = ans + 1;
  }
}

int makeans(int n){
  int ans = 0;
  for(int m = 0;m<n;m++){
    if(answer[m] > ans)ans = answer[m];
  }
  return ans;
}

void trace_back(int length,int ans,int start){
  int ret = 0;
  for(int n = 0;n<length;n++){
    if(answer[n] == ans)ansary[ans - 1] = input[n];
  }
  for(int n = ans - 1;n >= 1;n--){
    for(int m = length - 1;m >= 0;m--){
      if(n == answer[m] && input[m] < ansary[n])ansary[n-1] = input[m];
    }
  }
}

int main(void){
  int length = 0;
  while(1){
    printf("input length:");
    scanf("%d",&length);
    if(length <= 0)break;
    printf("input array:");
    for(int n = 0;n<length;n++){
      scanf("%d",&input[n]);
    }
    initialize(length);
    int ret = makeans(length);
    printf("Answer:%d\n",ret);
    trace_back(length,ret);
    printf("Answer Array:");
    for(int n = 0;n<ret;n++){
      printf("%d ",ansary[n]);
    }
    printf("\n\n");
  }
  return 0;
}
/*
実行例
input length:8
input array:1 5 7 2 6 3 4 9         
Answer:5
Answer Array:1 2 3 4 9 

input length:4
input array:1 5 6 8
Answer:4
Answer Array:1 5 6 8 

input length:4 
input array:5 2 6 9
Answer:3
Answer Array:5 6 9 

input length:30
input array:1 3 5 6 7 2 5 32 7 2 6 2 4 6 2 23 56 2 7 3 36 2 5 6 34 12 51 521 12 12    
Answer:9
Answer Array:1 3 5 6 7 32 36 51 521 

input length:0
*/
