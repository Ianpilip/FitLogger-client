// Format - 32 bit number. For Color() constructor

const int RED = 4294948277;
const int BLUE = 4290833407;
const int GREEN = 4290904001;
const int YELLOW = 4294967201;
const int BLACK = 4278190080;
const int GREY = 4286611584;
const int LIGHT_GREY = 4291348680;
const int LIGHT_LIGHT_GREY = 4294177779;
const int TRANSPARENT = 16777215;
const int SNOW = 4294966010;
const int GHOST_WHITE = 4294506751;


// Example of getting appropriate color integer from hex string
// String hexString = '#00FFFFFF';
// final buffer = StringBuffer();
// if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
// buffer.write(hexString.replaceFirst('#', ''));
// int color = int.parse(buffer.toString(), radix: 16);
// print(color);


// The function below should also work
// Color getColorFromColorCode(String code){
//   return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
// }