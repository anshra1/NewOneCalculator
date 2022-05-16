void main(){
 print(isDigit('.'));

 String ss = '-12345+';
 print(ss[ss.length-1]);
}

isOperator(String char) {
  if (char == '+' || char == '-' || char == 'x' || char == '\u00f7') {
    return true;
  } else {
    return false;
  }
}

isDigit(String char){
  if(char == 'AC' || char == '+/-' || char == '%' || char =='CE' || char == '.' || char == '=' || isOperator(char)){
    return false;
  }else{
    return true;
  }
}