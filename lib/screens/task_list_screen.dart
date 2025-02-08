import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import 'task_form_screen.dart';

//görevleri listeleyeceğimiz ana ekranın oluştuğu sınıfı başlattık.
class TaskListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const TaskListScreen({required this.onToggleTheme});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  /*
  Her bir görev ekleme işlemi için Task objelerinden oluşacak olan listemizi boş olarak oluşturduk.
  Peki ya bu task objeleri tam olarak ne?
  Kullanıcının kaydetmek istediği görevlerin tüm özelliklerini ayrı ayrı tutmak bizim için oldukça
  kafa karıştırıcı olur. Bu yüzden kullanıcının ekleyeceği her bir görevin tek bir obje halinde
  saklanması çok önemli. Bunun için kendi Task sınıfımızı oluşturarak bu objelerin özelliklerini
  kendi isteklerimiz ve uygulamanın ihtiyaçları doğrultusunda belirleyelim. Bu gibi objeleri models
  adında bir klasör oluşturarak içerisine ekleyebiliriz. screens klasörü gibi düzeni korumamız için
  bu klasörler önemli. models klasörü içindeki task.dart dosyasına bir göz atalım.
   */

  /*
  task.dart dosyasını inceledikten sonra liste içinde tutulması planlanan nesnelerin neye
  benzediği hakkında fikir sahibi olduk.
   */
  List<Task> _tasks = [];

  /*
  task.dart dosyasında gördüğümüz sıralama kriterlerinden date kriterini default olarak seçtik.
  böylece liste sıralandığında sıralama kriteri seçilene kadar date kriteri baz alınacak.
  bu bölümü TaskSortCriteria.name veya TaskSortCriteria.difficulty olarak değiştirerek deneyebilirsiniz.
   */
  TaskSortCriteria _sortCriteria = TaskSortCriteria.date;

  /*
  başlangıçta tanımladığımız değişkenlerimizi incelediğimize göre şimdi asıl büyünün gerçekleştiği
  build metoduna göz atalım. 161.satırda seni bekliyor!
   */

  /*
  Bu metodumuzu ise sıralama kriterlerine göre listeyi sıralamak için kullanıyoruz.
  switch case yapısı sayesinde sıralama butonunda seçilen kritere göre listeyi sıralıyoruz.
  sorted.sort(a,b) metodu bizim için kritere göre kıyaslamalarla sıralamayı yapıyor.
   */
  List<Task> get _sortedTasks {
    List<Task> sorted = List.from(_tasks);
    switch (_sortCriteria) {
      case TaskSortCriteria.date:
        sorted.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case TaskSortCriteria.title:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
        /*
        diğer sıralama kriterlerinden farklı olarak difficulty kriteri için ayrı bir metot
        oluşturduk. Bu metot color adında renk adı tutan değişkenler arasında sıralama yapamaz.
        bu yüzden get difficulty order fonksiyonu ile bizim her bir renkteki zorluk derecesini
        sayısal bir değere çevirerek sıralamayı bu sayılara göre belirlemeliyiz. Bunun için
        70.satırdaki _getDifficultyOrder fonksiyonunu inceleyelim.
         */
      case TaskSortCriteria.difficulty:
        sorted.sort((a, b) => _getDifficultyOrder(a.difficulty)
            .compareTo(_getDifficultyOrder(b.difficulty)));
        break;
    }
    return sorted;
  }

  /*
  Kullanıcıya sunduğumuz bu 4 renk için zorluk derecelerini sayısal bir değere çevirdik bu sayede
  sıralama yapılırken en zor görevleri en üstte görebileceğiz. Mesela kırmızı rengin değeri 4 olduğu
  için yeşil renkli ve değeri 1 olan görevlerden daha üstte yer alacak. Bu sayede kullanıcı aktif olan
  görevleri arasında en zor olanları daha kolay görebilecek.
   */
  int _getDifficultyOrder(Color color) {
    if (color == Colors.green) return 1;
    if (color == Colors.yellow) return 2;
    if (color == Colors.orange) return 3;
    if (color == Colors.red) return 4;
    return 0;
  }

  /*ekleme tuşuna bastığımızda çalışan metodumuz. burada amacımız kullanıcı yeni
  bir görev eklemek istediğinde yeni bir ekran açmak ve burada kullanıcıdan görev
  özelliklerini alarak task objesi halinde onSave: parametresiyle belirtilen _addTask
  metodunu çalıştırarak görevleri kaydetmek.
  */
  void _addNewTask(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //Bu kayıt ekranını oluştururken projenin okunabilirliğini korumak için
      //giriş listeleme ekranını koyduğumuz screens klasöründe task_form_screen.dart
      //adında kayıt ekranımızı içeren bir dosya oluşturduk. Hadi bu dosyayı inceleyelim
      //ardından buraya dönerek işlemi incelemeye devam edelim.
      builder: (ctx) => TaskFormScreen(
        onSave: _addTask,
      ),
    );
  }

  void _addTask(Task newTask) {
    setState(() {
      _tasks.add(newTask);
    });
  }

  /*
  Gördüğümüz üzere task_item üzerinde delete tuşuna basılan görevin id değeri
  parametre olarak gelmişti. burada da t.id == taskId ile _tasks listesinde
  id değeri taskId ile aynı olan (yani silmek istediğimiz task objesi) bulunur.
  ve bulunduğu yerde silinir. Böylece Silme işlemi tamamlanmış olur.

  SetState sayesinde de silme işlemi yapıldığı anda ekran güncellenir ve silinen
  görev listeden kaybolur. SetState yapısını silerek denerseniz yine tasks listesi
  üzerinden silme işlemi olur ancak yeni bir işleme kadar bu değişikliği
  gözlemleyemezsiniz. Bunu da denemenizi öneriyorum.
   */
  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((t) => t.id == taskId);
    });
  }

  /*
  task item üzerindeki son özelliğimiz olan güncelleme için çağırdığımız metodumuza
  bir göz atalım. delete metodundan farkının removeWhere yerine indexWhere olduğunu
  görüyoruz. Aslında bu da bulduğu yerde silmek yerine, güncellenecek olan görevin
  indexini bulup bu index içine güncel özellikleri taşıyan updatedTask objesi koyarak
  yaptık.
   */

  /*
  Eğer bu yorum satırına kadar ulaştıysan tebrikler, projenin tüm adımlarına hakimsin!
  main.dart dosyasında başlayan yolculuğumuz bu projede sona geldi. Şimdi sıra burada
  anladığım proje yapısını kendi projelerin üzerinde uygulamakta.
  Yeni yolculuklarda başarılar!
   */

  void _updateTask(Task updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) _tasks[index] = updatedTask;
    });
  }

  void taskDone(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  /*
  İşlerin asıl yürüdüğü yere hoş geldin! Nasıl main.dart dosyasında build ile
  uygulamamızın ana widget'ını oluşturduysak burada da aynı işlemi yapıyoruz.
  Hatırlarsak main.dart içindeki build metodunda home parametresi bizi bu metoda
  yönlendirmişti. Yani burada yapacaklarımız ekranda görünecek ilk ekranı oluştacak.
  Öyleyse adım adım kodun içine girelim.
   */
  @override
  Widget build(BuildContext context) {
    // Scaffold widget'ı ile uygulamamızın ana yapısını oluşturuyoruz. Verdiğimiz parametrelerle
    // ekranımızı dolduracağız.
    return Scaffold(
      // İlk olarak appBar parametresi ile ekranımızın üst kısmında bir alan ayırıyoruz.
      // Bu alana hem başlığımızı hem de uygulamamızın temasını değiştirecek olan butonumuzu ekliyoruz.
      appBar: AppBar(
          // Metin girebilmek için Text() metodunu atlamıyoruz.
          title: Text('Tasks'),
        //actions bizim için çalışır halde bir buton oluşturacak.
        actions: [
          IconButton(
            //icon parametresi ile butonun içindeki simgeyi,
            icon: Icon(Icons.brightness_6),
            //onPressed parametresi ile de butona basıldığında ne olacağını belirliyoruz.
            //temayı değiştiren metodu çalıştırmayı seçtik.
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      /*
      appbar ile ekranın üst bölümünde ayırıp doldurduğumuz bölümden sonra şimdi ekranın
      geri kalan kısmını dolduracak olan body parametresine geçiyoruz. Amacımız sıralama
      kriterini seçtiğimiz bir bölüm, altında görevlerin listelendiği görevler alanı,
      en altta ise görev eklemek için bir buton oluşturmak. Önce Ekleme tuşu ve ekleme
      ekranını görelim. 289.satıra bakalım.
        */

      /*
      Anlaşılan Form ekranını tamamladın. Çok iyi ilerliyorsun tebrikler!
      Artık görevleri _tasks listemizin içinde tutuyoruz. Sırada bu görevleri
      sıralayarak ekrana getirmek var. Bunun için aşağıdaki body bölümü üzerinde
      devam edelim.
       */

      body: Column(
        children: [
          //Padding ile belli bir boşluk bırakıyoruz.
          Padding(
            padding: const EdgeInsets.all(8.0),
            //Ardından row ile satır yapısında kriterlerin sıralanmasını sağlıyoruz.
            child: Row(
              children: [
                Text('Sort: '),
                //DropdownButton açıldığında aşağıya doğru kriterleri sıralayan bir buton oluşturacak.
                DropdownButton<TaskSortCriteria>(
                  //sıralanacak kriterler de bu sınıfta tanımladığımız _sortCriteria değişkeninden
                  // alınacak. 35.satırı inceleyebilirsin.
                  value: _sortCriteria,

                  //onChanged ise bize bu kriter seçeneklerinden biri seçildiğinde ne yapılacağını belirler.
                  //Anlık olarak yeni kritere göre sıralanmış görevleri görmek istediğimiz için setState
                  //ile sayfayı yeniliyoruz.
                  onChanged: (TaskSortCriteria? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _sortCriteria = newValue;
                      }
                    });
                  },

                  //Bu kısım sıralama ekranında hangi yazının görüneceğini belirleyen
                  // yer. Mesela date seçildiyse bu bölümde 'by date' yazmasını sağlar.
                  //Bunun için 307.satırdaki _getSortCriteriaText fonksiyonunu inceleyebilirsin.
                  //Ardından 248.satırdan devam ediyoruz.
                  items: TaskSortCriteria.values.map((criteria) {
                    return DropdownMenuItem<TaskSortCriteria>(
                      value: criteria,
                      child: Text(
                        _getSortCriteriaText(criteria),
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          /*
          En önemli ve en zor kısma geldik. Bu bölüm hem görevlerin sıralandığı hem
          ekrana yansıtıldığı, hem güncelleme silme gibi özelliklerinin tanımlandığı yer.
          Bu yüzden bu bölümü çok iyi anlamalıyız. İlk olarak Expanded widget'ı ile alanımızı
          ekrandaki boş alanı dolduracak şekilde tasarladık. Yani body bölümünde geriye kalan
          alanın tamamını bu alana ayırdık.
           */
          Expanded(
            /*İlk olarak _sortedTasks kullanarak _tasks listesinde anlık olarak bulunan tüm
            görevlerin sıralanmış halini elde ederek boş olup olmadığını kontrol ediyoruz.
            Bunun için dart derslerinde gördüğümüz .isEmpty metodunu kullandık.
            Bu kontrol yapısında sortedTasks.isEmpty değeri eğer true ise listenin boş
            olduğunu anlar ve ? karşısındaki kısmı çalıştırır. Bu da Center widget'ı
            sayesinde alanımızın en ortasına 'You have no tasks yet!' yazısını yerleştirir.
            Eğer false ise : karşısındaki kısmı çalıştırır. Bu da ListView.builder ile
            görevlerin listelendiği alanımızı çalıştırır. Şimdi bu ListView alanımızı nasıl
            oluşturduğumuza bakalım.
             */
            child: _sortedTasks.isEmpty ? Center(child: Text('You have no tasks yet!')) :
            /*
            Listenin boş olmadığını anladığımızda kodumuz artık burada demektir.
            ListView.builder sayesinde mecvut olan tüm görevlerimizi listeriz.
            itemCount parametresi ile görev sayısını belirtmeliyiz bunu da .length
            metoduyla kolayca yaptık. Ardından her bir görevin içeriğini hazırlamamız gerek.
            Nasıl her bir task objesini task.dart içerisinde tanımladıysak burada da
            listeleyeceğimiz her bir task objesini TaskItem widget'ı ile oluşturalım.
            models gibi bir de widgets adında bir klasör oluşturarak içerisine task_item.dart
            dosyasını ekleyebiliriz. Şimdi bu dosyayı inceleyip buraya geri dönelim.
            */
            ListView.builder(
              itemCount: _sortedTasks.length,
              itemBuilder: (ctx, index) => TaskItem(
                _sortedTasks[index],
                onDelete: _deleteTask,
                onUpdate: _updateTask,
              ),
            ),
          ),
        ],
      ),

      /*
      Ekranın en altına işlevsel bir buton ekliyoruz. Böylece kullanıcı görevlerini
      ekleyebilecek. Ancak görevlerin eklenebilmesi için bir form oluşturmalıyız.
      Yani kullanıcıların görev özelliklerini girecekleri alanlar olmalı. Bunu yeni
      bir ekran oluşturarak yapabiliriz. Bu yeni ekranımımızı da task_list_screen.dart
      dosyasını eklediğimiz gibi screens klasörüne ekleyerek task_form_screen.dart adını verdik
       */
      floatingActionButton: FloatingActionButton(
        //butonun üzerindeki ikonu burada belirledik. Icon(Icons.add_box) gibi
        //farklı ikonlar ya da Text('Add') gibi metin içeren bir buton halinde
        //deneyebiliriz.
        child: Icon(Icons.add),
        //Butona basıldığında yeni görev eklemek için oluşturduğumuz metodumuz
        //çağırılıyor. 89.satıra giderek bu metodu inceleyeyelim.
        onPressed: () => _addNewTask(context),
      ),
    );
  }

  String _getSortCriteriaText(TaskSortCriteria criteria) {
    switch (criteria) {
      case TaskSortCriteria.date:
        return 'by date';
      case TaskSortCriteria.title:
        return 'by name';
      case TaskSortCriteria.difficulty:
        return 'by difficulty';
    }
  }
}
