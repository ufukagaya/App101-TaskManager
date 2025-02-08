import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';

/*
Öncelikle hoşgeldin yolcu!
Bu projede amacımız projeyi bilgisayar gözünden adımlarıyla görmek ve neyin nasıl
ve neden çalıştığını anlamaya çalışmak. Bunun için farklı kod dosyaları arasında
yolculuklara çıkıp adım adım neler olup bittiğini takip edeceğiz.
Yönergeleri sırayla takip edersen projenin tüm hatlarına hakim olacaksın.
Bu sayede yapay zeka destekli bir uygulama oluşturduğunda dahi işleyişi biliyor
ve sorunla karşılaştığında bilgilerini kullanabiliyor olacaksın.
Hazırsan başlayalım.
 */


/*
Bu dosya uygulamamızın ana dosyasıdır. Uygulamamızın başlangıç noktasıdır.
Uygulamamızı çalıştırdığımızda bilgisayarın ilk arayacağı ve çalıştıracağı yerdir.
Tüm kodumuzu bu dosya üzerinden yöneteceğiz. Karmaşıklığı önlemek ve daha okunabilir bir yapı için
kodu farklı dosyalara ayırarak bu ana dosya üzerinden yönlendireceğiz.
 */



//uygulamayı başlatıyoruz
void main() => runApp(MyApp());

//Uygulamamızın ana widget'ını stateful oluşturuyoruz çünkü tema özelliğimiz state yönetimi geretiriyor.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //ThemeMode adındaki hazır state değişkenimizle tema modunun güncel halini tutuyoruz.
  ThemeMode _themeMode = ThemeMode.light;

  //Tema değişimini uyguluyoruz. Eğer mevcut tema light ise dark, dark ise light yapıyoruz.
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      //tema tasarım özelliklerini belirliyoruz. Mavi rengini seçtik üzerinde değişiklikler yapabilirsiniz.
      theme: ThemeData(primarySwatch: Colors.blue),

      //dark mod seçildiğinde görünecek olan temayı belirliyoruz. Varsayılan ayarı seçtik.
      darkTheme: ThemeData.dark(),

      //tema modunu belirliyoruz. _themeMode değişkenimizi kullanıyoruz.
      themeMode: _themeMode,

      /*
      Bu bölüm programımız için en kilit noktalardan birisi. İlk olarak home parametresi için
      basit bir örnek widget oluşturmayla başladık. Ekranda bizi karşılayan widget'ımızı bu bölüm
      belirlediği için ana özelliklerimizi tam burada örnek bir görüntüyle test edelim. home
      parametresi için mevcut olan metod yerine aşağıda vereceğim örneği deneyerek uygulamamızın
      temelini bu parametrenin oluşturduğunu anlayabiliriz:
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Başlık"),
        ),
        body: const Center(
          child: Text("Gövde"),
        ),
      ),

      Görevlerimizi listeleyeceğimiz ekranı TaskListScreen adında bir metod içerisinde belirledik.
      Karmaşıklığı azaltmak için ilk ekranımız olacak olan bu metodu screens adında bir klasör
      oluşturarak içerisine ekledik.
      Şimdi kodu incelemeye task_list_screen.dart dosyasından devam edelim.
      */
      home: TaskListScreen(onToggleTheme: _toggleTheme),
    );
  }
}