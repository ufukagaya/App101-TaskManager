import 'package:flutter/material.dart';
import '../models/task.dart';

//Görev kaydetme ekranına hoş geldiniz! Bu ekranı oluştururken kullanıcıdan gerekli
//olan tüm bilgiler alınarak daha öncesinde tanımladığımız Task objesi halinde kaydetmeyi
//ardından tasks listesine kaydederek görüntülenme aşamasında ekranda belirmesini sağlayacağız.

class TaskFormScreen extends StatefulWidget {
  //burada mevcut task objelerinin varlığı ve halihazırda kaydedilmiş olup olmadığını
  //kontrol etmek için kontrol değişkenlerimizi oluşturduk.
  final Function(Task) onSave;
  final Task? existingTask;

  //ekleme işlemi yaparken kullanıcıdan alınan bilgileri kaydetmek için onSave fonksiyonunu
  //kullandık. Ayrıca mevcut task objesini kontrol etmek için existingTask değişkenini
  //kullandık.
  const TaskFormScreen({required this.onSave, this.existingTask});

  //TaskFormScreen sınıfımızın state'ini ve böylece _TaskFormScreenState
  //sınıfımızı oluşturduk. işlemlerimizi bu sınıf üzerinden yöneteceğiz.
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

/*
Kayıt işlemlerini yönettiğimiz sınıfımız. Bu sınıf üzerinden kullanıcıdan alınan
bilgileri kontrol ederek kayıt işlemlerini, güncelleme silme ve yapıldığını belirtme
işlemlerini yöneteceğiz.

İlk olarak sınıf içinde tanımlanan değişkenleri inceleyelim.
titlecontroller ve descrptioncontroller değişkenleri kullanıcıdan alınan başlık ve
açıklama bilgilerini kontrol etmek için kullanıldı. Ancak bütün bu state yönetimini
initState() metodu içinde hazırladık. BU metod sayesinde kullanıcının bize verdiği
değerler kontrol edilerek başlatılmış oldu.

State yönetimini kurduğumuza göre kullanıcıya gösterilecek olan ekranı oluşturacağımız
ve yönlendirmeleri yapacağımız build metoduyla başlayalım. bunun için 102.satırda
build metodumuzu inceleyelim.
*/

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingTask?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingTask?.description ?? '');
    _selectedDate = widget.existingTask?.deadline ?? DateTime.now();
    _selectedColor = widget.existingTask?.difficulty ?? Colors.red;
  }

  /*
  Form işlemimizin son adımı olarak kullanıcıdan aldığımız tüm bilgileri,
  tuttuğumuz değişkenlerden alarak bir Task classından bir obje haline getirerek
  task adında objemizi oluşturup widget.onSave(task) metodu ile tasks listesine
  kaydetme işlemini gerçekleştirdik.

  Tebrikler! Artık kaydetme işlemini tamamladın. Artık sırada listede görevlerimizi
  görmek sıralamak silmek ve güncellemek var.
  Devam etmek için task_list_screen.dart dosyasında 198.satırda görüşelim!

   */

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.existingTask?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _selectedDate,
        difficulty: _selectedColor,
        isCompleted: widget.existingTask?.isCompleted ?? false,
      );
      widget.onSave(task);
      Navigator.of(context).pop();
    }
  }

  /*
  Tarih seçme işlemini yönettiğimiz metodumuz. Kullanıcı 'Pick date' butonuna
  tıkladığında showDatePicker metodu sayesinde kullanıcının takvim üzerinden kolayca
  tarih seçmesi sağlanacak. ardından setState sayesinde bu seçilen tarih _selectedDate
  değişkenine atanarak diğer işlemlerde hangi tarihin seçildiğini görebileceğiz.
  Şimdi 160.satırdan devam edelim.
   */
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() => _selectedDate = pickedDate);
      }
    });
  }

  //Kullanıcıdan bilgilerin alınacağı form ekranını oluşturduğumuz alan burası.
  //Gerekli bilgileri alıp kaydetme işlemine yönlendireceğiz.
  @override
  Widget build(BuildContext context) {
    //Öncelikle kayıt ekranı için ekranın alt yüzünde biralan açıyoruz.
    return Padding(
      //Alanımızın padding ayarlarını yapıyoruz. Burada değerleri değiştirerek
      //form ekranını kurcalayabiliriz.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 15,
        left: 15,
        right: 15,
      ),
      //Bu kısımdaysa artık kullanıcıdan görev bilgilerini alacağımız formu oluşturuyoruz.
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          //Her bir sekme birer children olarak ayrılıyor.
          child: Column(
            //Başlığı sorduğumuz children
            children: [
              //Kullanıcıya görev başlığını gireceği bölümü TextFormFiled ile hazırlıyoruz.
              TextFormField(
                //Bu adımda alanın kontrolünü sağalamak için TextFieldController
                //objemizi kullanıyoruz. Class'ın başında tanımladık.
                controller: _titleController,
                //Bu bölüm aslında kullanıcıdan bilgiyi aldığımız metin girilebilir alan.
                //Metin girilebilir alanı InputDecoration sayesinde oluşturduk.
                decoration: const InputDecoration(labelText: 'Title'),
                //bu alanın boş bırakılmaması gerektiğini belirtmek için bir validator
                //ekledik. Bu sayede eğer kullanıcı başlık belirlemezse uygulamamız
                //bu durum için bir hata mesajı gösterecek.
                validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
              ),

              //Görev için başlık istediğimiz alanın altında bir de açıklama istediğimiz
              //bölüm hazırladık. Title alanından farklı olarak açıklama alanını zorunlu
              //tutmamak için validator kullanmadık. Ve bu alanı maxLines parametresiyle
              //3 satırda sınırladık.
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),

              //Şimdi sıra tarih seçme bölümünde. Önce SizedBox ile tarih seçimine ayrılan
              // alanın boyutu belirlendi. Başlık ve açıklama gibi doğrudan metin ile belirledik.
              //Ancak metin ile son tarih belirlemek kullanış açısından çok iyi bir yöntem değildi.
              // Bu yüzden üzerinde 'Pick date' yazan bir buton ekledik ve bu buton ile seçim
              // işlemlerini yönettik. Ayrıca kullanıcı için seçtiği tarihi hatırlaması için
              //bu butonun yanına seçili olan tarihi gösteren bir alan ekledik.

              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    //tarih seçildiğinde selectedDate değişkenine atanacağı için bu değişkeni
                    //kullanarak tarihi gösteren bir alan oluşturduk.
                    child: Text(
                      ': ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                  //Tarih seçme işlemini başlık ve açıklamadan ayrı olarak _presentDatePicker
                  //adında bir metod üzerinden yapmayı planladık. 83.satırda bu metodu inceleyelim.

                  TextButton(
                    child: Text('Pick date'),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),

              /*
              Tarih seçme alanı gibi yine SizedBox kullanarak bir alan oluşturduk.
              Zorluk seviyesini yazıyla değil renkle belirlemek istediğimiz için
              ekrana basılabilir 4 adet renk seçeneği oluşturacak olan
              _buildColorChoice metodumuzu çağırdık. 217.satırda bu metodumuzu
              inceleyelim.
               */
              SizedBox(height: 15),
              Text('Difficulty:', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildColorChoice(Colors.red, 'Red'),
                  _buildColorChoice(Colors.orange, 'Orange'),
                  _buildColorChoice(Colors.yellow, 'Yellow'),
                  _buildColorChoice(Colors.green, 'Green'),
                ],
              ),

              /*
              Artık tüm verileri kullanıcıdan aldık ve geriye bu verileri
              kaydetmek kaldı. Bunun için kayıt butonu ekledik ve bir kayıt
              ikonu kullandık. Basıldığında ise topladığımız bilgileri tasks
              listesi içine kaydetmesi için_submit metodunu çağırdık.
              59.satıra giderek bu metodu inceleyelim.
              */
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _submit();
                },
                child: Icon(Icons.save),),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  //Parametre olarak gelen renkleri InkWell widget'ı sayesinde tıklanabilir
  //yuvarlak butonlar haline getirdik.

  Widget _buildColorChoice(Color color, String label) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _selectedColor = color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              //renk olarak metodu çağırırken verdiğimiz parametreyi kullandık.
              color: color,
              //şekil olarak yuvarlak seçtik ancak bunu değiştirerek deneyebiliriz
              shape: BoxShape.circle,
              //daha iyi bir görünüm için kenarlık ekledik.
              border: _selectedColor == color
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
            ),
          ),
        ),
        //metodu incelediğimize göre 196.satıra dönelim.
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}