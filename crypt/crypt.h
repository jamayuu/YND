#pragma once

#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using std::cout;
using std::endl;
using std::ios;
using std::ofstream;
using std::ifstream;
using std::string;
using std::vector;

typedef char cryption_key_type;

#define BUFFER_PATH "buffer"

namespace crypt{
  //file_convert(元のファイル、出力ファイル、鍵)
  //元ファイル変換結果を保存する、普通のファイルは暗号化ファイルに、暗号化ファイルは元ファイルに戻る
  bool file_convert(string origin,string out_name,cryption_key_type key){
    ifstream ifs(origin, ios::in | ios::binary);
    ofstream ofs(out_name, ios::out|ios::binary|ios::trunc);
    if(!ifs || !ofs)return false;
    cryption_key_type input,cry;
    while(true){  //ファイルの最後まで続ける
        ifs.read( ( char * ) &input, sizeof(cryption_key_type) );
        if(ifs.eof())break;
        cry = input^key;
        ofs.write(( char * ) &cry,sizeof(cryption_key_type) );
    }
    ifs.close();
    ofs.close();
    return true;
  }

  bool file_change(string origin,cryption_key_type key){
    ifstream ifs(origin, ios::in | ios::binary);
    ofstream ofs(BUFFER_PATH, ios::out|ios::binary|ios::trunc);
    if(!ifs || !ofs)return false;
    cryption_key_type input,cry;
    while(true){  //ファイルの最後まで続ける
        ifs.read( ( char * ) &input, sizeof(cryption_key_type) );
        if(ifs.eof())break;
        cry = input^key;
        ofs.write(( char * ) &cry,sizeof(cryption_key_type) );
    }
    ifs.close();
    ofs.close();
    if(!std::filesystem::remove(origin))return false;
    std::filesystem::rename(BUFFER_PATH,origin);
    return true;
  }

  bool save_var(string out_name,char *input,int size,cryption_key_type key=(cryption_key_type)NULL){
    if(key != (cryption_key_type)NULL){
      ofstream ofs(out_name, ios::out|ios::binary|ios::trunc);
      if(!ofs)return false;
      ofs.write(input,size);
      ofs.close();
      file_change(out_name,key);
    }else{
      ofstream ofs(out_name, ios::out|ios::binary|ios::trunc);
      if(!ofs)return false;
      ofs.write(input,size);
      ofs.close();
    }
    return true;
  }

  bool load_var(string input_name,char *output,int size,cryption_key_type key=(cryption_key_type)NULL){
    if(key != (cryption_key_type)NULL){
      if(!file_convert(input_name,BUFFER_PATH,key))return false;
      ifstream ifs(BUFFER_PATH, ios::in | ios::binary);
      if(!ifs)return false;
      ifs.read(output,size);
      ifs.close();
      if(!std::filesystem::remove(BUFFER_PATH))return false;
    }else{
      ifstream ifs(input_name, ios::in | ios::binary);
      if(!ifs)return false;
      ifs.read(output,size);
      ifs.close();
    }
    return true;
  }

}
