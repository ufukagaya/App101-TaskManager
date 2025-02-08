import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/task_form_screen.dart';
/*
Buraya geldiğine göre listeleme işleminde ilerlemiş olmalısın. Güzel!

Burada widget'ımızı oluşturduk ve içerisine daha önce oluşturduğumuz task objesini,
silme ve güncelleme işlemleri için gerekli olan onDelete ve onUpdate fonksiyonlarını
parametre olarak aldık.
 */

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String) onDelete;
  final Function(Task) onUpdate;

  /*
  Task.dart dosyasında, projenin devamında task objesi oluştururken kullanacağız
  diye bahsederek bir constructor oluşturmuştuk. Aynısını burada da yaparak ileride
  oluşturacağımız task_item.dart dosyasında kullanacağımız task objesini oluşturduk.
  uygulamayı çalıştırdığımızda ve task eklediğimizde ekrana gelecek olan o obje tam
  olarak bu obje olacak.
   */
  const TaskItem(this.task, {required this.onDelete, required this.onUpdate});

  /*Görevleri listelerken her bir görev için ekranda belirecek olan görüntüyü aslında
  bu build metodu belirliyor. Birazdan kod içinde bazı bölümleri kurcalayarak bunu daha
  iyi anlayacağız.
   */
  @override
  @override
  Widget build(BuildContext context) {
    //tema düzenlememizi yapıyoruz. Böylece karanlık temada görev daha iyi görünecek.
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    //Container yapısı birden fazla görev objemizi sıralı halde görmemizi sağlıyor.
    return Container(
      //Container'ın margin parametresi her bir görev için ayrılan bölümü belirler.
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        //aydınlık modda Colors.white ile beyaz, karanlık modda ise gri bir görünümde
        //olmasını ayarlar.
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        //borderRadius ve border ise göre görev kutucuklarının kenarlıklarını oluşturur.
        //zorunlu parametreler değildir silmeyi deneyin.
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black, width: 1.0),
      ),

      //Görevin yer aldığı kutunun tasarımı tamamlandığına göre içeriğini belirleyen
      //child'a bakabiliriz.
      //Burada Görev kutucuğunda gösterilecek olan her şey yer almalı. Sırayla
      //üzerlerinden geçelim.
      child: ListTile(

        //görev için seçilmiş olan zorluk renginde bir daire görünür.
        //görevin zorluk seviyesi task.difficulty ile elde ettik.
        leading: CircleAvatar(backgroundColor: task.difficulty),

        //benzer şekilde task.title ile görev adı alınır ve rengi temaya uygun
        //halde kontrol ettik.
        title: Text(
          task.title,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),

        //tarihin yazı formatında görüntülenmesi için task.deadline özelliğinin
        //.day .month gibi özellikleriyle tam tarih alınır ve yazdırdık.
        subtitle: Text(
          '${task.description}\nDeadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),

        //Görev kutucuğunun solunda tüm bilgilerini gösterdik, sırada sağ tarafta
        //güncelleme ve silme seçeneklerini bulunduran üç nokta ve görevin bitmesini
        //ifade eden tik butonu yer alacak. Yine Row ve mainAxisSize parametrelerini
        //kullandık.
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          //Tik ikonu ile görevin tamamlanıp tamamlanmadığı görebiliyoruz.
          //Bu butona basıldıkça Task objesinin isCompleted özelliğini güncelliyoruz.
            children: [
              IconButton(
                icon: Icon(
                  task.isCompleted? Icons.check_box_rounded : Icons.check_box_outlined,
                  color: task.isCompleted? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  onUpdate(Task(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    deadline: task.deadline,
                    difficulty: task.difficulty,
                    isCompleted: !task.isCompleted,
                  ));
                }
              ),

              //Tik butonunun sağındaki 3 noktayı ise tam olarak burada yönetiyoruz.
              //3 noktaya basılınca bir popup menu açılıyor ve delete, edit seçenekleri
              //görünüyor.
              PopupMenuButton<String>(
                //onSelected bu iki seçim arasında kullanıcının hangisine bastığında
                //neler yaşanacağını belirler. (Aynı onPressed gibi çalışır.)
                onSelected: (value) {
                  /*
                  Eğer delete butonuna basıldıysa onDelete(task.id) metodu çalıştırılır.
                  onDelete metodu, task_list_screen.dart üzerinde TaskItem widget'ı
                  oluşturulurken parametre olarak gönderilen bir fonksiyondur. Bu yüzden
                  bu fonsiyonu çağırırken hangi metodla çağırıldığını hatırlamamız gerek.
                  task_list_screen.dart üzerinde 280.satıra bakıp geri gelelim.
                  */

                  /*
                  Gördüğümüz gibi TaskItem çağırılırken task_item_screen.dart içindeki
                  _deleteTask ve _updateTask metodları ile çağırılmış. Bu da demek ki
                  burada ondelete(task.id) kullanmamız aslında _deleteTask(task.id)
                  anlamına geliyor. task_list_screen.dart üzerindeki 116.satırda bu
                  işleme bakıp dönelim.
                   */

                  //Delete işlemini tamanladığımıza göre edit işlemine geçelim.

                  if (value=='delete') {
                    onDelete(task.id);
                    //Eğer edit butonuna basıldıysa _showEditDialog metodu çalıştırılır.
                  } else if (value=='edit') {
                    _showEditDialog(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
        ],
      ),
    ),
    );
  }

  /*
  Edit tuşuna basınca ekranda aslında kayıt ekranımızın aynısı belirecek.
  bunu da doğrudan builder içine TaskFormScreen widget'ını ekleyerek yaptık.
  mevcut değerleri güncelleyip kaydetme tuşuna tekrar basarak güncel
  içeriğimizi updatedTask objesiyle kaydedebiliyoruz.

  Kaydettiğimiz bu updatedTask objesini onDelete parametresinde olduğu gibi
  onUpdate parametresi üzerinden gelen metodu uyguluyoruz. TaskItem metodunu
  çağırdığımız task_list_screen.dart dosyasındaki 281.satıra bakarak burada
  onUpdate parametresi için _updateTask() metodunu seçtiğimizi görüyoruz.

  task_list_screen.dart dosyasında 133.satıra bakarak bu metodu inceleyelim.
   */
  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => TaskFormScreen(
        existingTask: task,
        onSave: (updatedTask) => onUpdate(updatedTask),
      ),
    );
  }
}