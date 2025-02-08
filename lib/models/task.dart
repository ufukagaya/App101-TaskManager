import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/*
task_list_screen.dart dosyasında gördüğümüz bu objeleri oluşturmak için Task
sınıfını oluşturduk. Bu sınıfı oluştururken Equatable paketini ekledik.

Peki ya nasıl ekledik?
Bu özelliğin çalışır halde olması için projeyi geliştirme aşamasında pubspec.yaml
dosyası içinde depedencies bölümü altında equatable: ^2.0.5 versiyonunu ekleyerek.
Bu pubspec.yaml dosyamızda mevcut. Ama projeyi yaparken eklediğimizi unutmayalım.

Bu paket ileride kullanıcının oluşturduğu objeleri listelerken sıralama yapmamızda
yardımcı olacak. Ayrıca her bir görevin benzersiz ve karşılaştırılabilir olması için
id değişkeni ile birlikte kullanıcıdan alınacak bilgiler bu sınıfta tutulacak.
 */

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  /*
id,title,description değişkenleri metin formatında alınırken deadline
değişkeni kullanım kolaylığı sağlaması açısından hazır DateTime sınıfı ile oluşturuldu.
Bu sayede kullanıcı tarih seçimini takvim üzerinden kolayca yapabilecek.
   */
  final DateTime deadline;
  /*
difficulty değişkeni ise görevin
zorluk derecesini belirlemek için kullanıldı. Bu değişkenin tipi Color olduğu için görsel olarak
kullanıcının zorluk derecesini daha kolay anlamasını sağlayacak şekilde tasarladık.
   */
  final Color difficulty;
  /*
Son olarak eklediğimiz isCompleted değişkeniyle ise görevlerin tamamlandığını göstermek için
eklediğimiz tik işaretinin değerini boolean (yani true veya false) olarak belirleyeceğiz.
(Bu bölümde önerisi için Rümeysa'ya teşekkür ederim.)
   */
  bool isCompleted = false;

  /*
  Sınıfımızın constructor metodunu oluşturuyoruz. Bu aslında projenin devamında task objesi
  oluşturma, güncelleme ve silme işlemlerinde kullanılacak fonksiyonumuz olduğu için oldukça önemli
  bir kısım. Bu metodu oluştururken id, title, description, deadline ve difficulty değişkenlerini
  zorunlu olarak almasını sağladık bu sayede herhangi bir özelliği eksik olan bir task objesi
  oluşturulmamış olacak. isCompleted değişkeni ise varsayılan olarak false değerini aldı.
   */
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.difficulty,
    this.isCompleted = false,
  });

  /*
  Equatable paketini kullanarak objelerimizi karşılaştırabilir hale getiriyoruz. Bu sayede
  objelerimizi sıralarken ve karşılaştırırken daha kolaylık sağlamış olacağız. Bu metodu
  oluştururken sadece id değişkenini baz alarak karşılaştırma yapmasını sağladık. Bu sayede
  her bir görevin benzersiz olmasını sağlamış olduk.
   */
  @override
  List<Object?> get props => [id];
}

/*
Görevlerin listelendikten sonra istediğimiz kriterlere göre sıralanmasını sağlamak için
TaskSortCriteria adında bir enum oluşturduk. Bu enum içerisinde date, title ve difficulty
değişkenlerini tanımladık. Bu sayede ileride sıralama özelliğini hazırlarken TaskSortCriteria
metodunu kullanarak sıralama yapabileceğiz.
   */
enum TaskSortCriteria { date, title, difficulty }

/*
task.dart dosyasını incelediğimize göre task_list_screen.dart dosyasında kaldığımız yerden devam edebiliriz.
 */