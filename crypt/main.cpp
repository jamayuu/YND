#include "crypt.h"
#include <iostream>
//使用例

int main(){
  //なんでもいいので変数を用意、構造体やクラスでも良い。
  double unchi = 114.514;

  //鍵の変数の宣言(デフォルトではchar型)
  cryption_key_type key = 19;

  //(保存先、変数のアドレス((char *)でキャストすること)、その変数のサイズ(意味不ならコピペ)、鍵)
  //ファイルとして変数unchiを暗号化して保存する。
  crypt::save_var("data/unchi",(char *)&unchi,sizeof(unchi),key);

  //(ロード元、変数のアドレス((char *)でキャストすること)、その変数のサイズ(意味不ならコピペ)、鍵)
  //ファイルとして保存された変数unchiを暗号化を解除してロードする。
  double load;
  crypt::load_var("data/unchi",(char *)&load,sizeof(load),key);

  //ロードした結果が正しいかの確認
  cout << "unchi: " << unchi << endl;
  cout << "load:  " << load  << endl;

  /*
  先の２つは鍵を省略して、
  crypt::save_var("data/unchi",(char *)&unchi,sizeof(unchi));
  crypt::load_var("data/unchi",(char *)&load,sizeof(load));
  と書くことも可能。あまりないと思うが、暗号化をせずに保存、ロードができる。
  */

  //ファイルの暗号化及び解読
  //(元のファイル、出力ファイル、鍵)
  //暗号化
  crypt::file_convert("data/unko.gif","data/unko_crypt.gif",key);
  //解読
  crypt::file_convert("data/unko_crypt.gif","data/unko_discrypt.gif",key);
  //同じ関数で解読も暗号化も行うことができる。よかったね。

  //file_changeもあるが、ほぼ同じなので割愛
  //ヘッダーに説明があるため読んでください。
  return 0;
}
