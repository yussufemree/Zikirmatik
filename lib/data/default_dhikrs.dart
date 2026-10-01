import '../models/dhikr_model.dart';

class DefaultDhikrs {
  static List<DhikrModel> get list => [
        // Namaz Tesbihatı
        DhikrModel(
          id: 'subhanallah',
          title: 'Sübhanallâh',
          arabic: 'سُبْحَانَ اللَّهِ',
          meaning: 'Allah her türlü noksan ve eksik sıfatlardan münezzehtir.',
          virtue:
              'Peygamberimiz (s.a.v.): "Her namazdan sonra 33 defa Sübhanallah diyenin günahları deniz köpüğü kadar da olsa bağışlanır." buyurmuştur.',
          target: 33,
          category: 'Namaz Tesbihatı',
        ),
        DhikrModel(
          id: 'elhamdulillah',
          title: 'Elhamdülillâh',
          arabic: 'الْحَمْدُ لِلَّهِ',
          meaning: 'Hamd ve övgülerin tamamı sadece Allah\'a aittir.',
          virtue:
              '"Elhamdülillâh mizanı doldurur." Nimetlerin şükrü ve manevi huzur için en faziletli zikirlerdendir.',
          target: 33,
          category: 'Namaz Tesbihatı',
        ),
        DhikrModel(
          id: 'allahu_ekber',
          title: 'Allâh-u Ekber',
          arabic: 'اللَّهُ أَكْبَرُ',
          meaning: 'Allah en büyüktür, O\'nun azametine denk hiçbir şey yoktur.',
          virtue:
              'Kalpteki vesveseleri yok eder, kula Allah\'ın sonsuz kudretini hatırlatır.',
          target: 33,
          category: 'Namaz Tesbihatı',
        ),
        DhikrModel(
          id: 'kelime_i_tevhid',
          title: 'Lâ ilâhe illallâh',
          arabic: 'لَا إِلٰهَ إِلَّا اللَّهُ',
          meaning: 'Allah\'tan başka ilah yoktur.',
          virtue:
              'Zikrin en faziletlisidir. Kalbi arındırır, imanı tazeler ve cennetin anahtarıdır.',
          target: 100,
          category: 'Günün Zikirleri',
        ),
        DhikrModel(
          id: 'estagfirullah',
          title: 'Estağfirullâh el-Azîm',
          arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ',
          meaning: 'Yüce Allah\'tan bağışlanma diliyorum.',
          virtue:
              'Rızkı bollaştırır, dert ve kederleri giderir, kalpteki manevi pası temizler.',
          target: 100,
          category: 'Günün Zikirleri',
        ),
        DhikrModel(
          id: 'salavat',
          title: 'Salavât-ı Şerîfe',
          arabic: 'اللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ',
          meaning: 'Allah\'ım! Efendimiz Hz. Muhammed\'e rahmet ve selam eyle.',
          virtue:
              '"Bana bir defa salavat getirene Allah on defa rahmet eder, on günahını siler."',
          target: 100,
          category: 'Günün Zikirleri',
        ),
        DhikrModel(
          id: 'subhanallahi_ve_bihamdihi',
          title: 'Sübhanallâhi ve Bihamdihî',
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          meaning: 'Allah\'ı hamd ile tesbih ederim.',
          virtue:
              'Günde 100 defa söyleyenin günahları deniz köpüğü kadar da olsa dökülür.',
          target: 100,
          category: 'Günün Zikirleri',
        ),
        DhikrModel(
          id: 'la_havle',
          title: 'Lâ Havle Ve Lâ Kuvvete İllâ Billâh',
          arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          meaning: 'Güç ve kuvvet ancak şanı yüce olan Allah\'a aittir.',
          virtue:
              'Cennet hazinelerinden bir hazinedir; çaresizlik ve sıkıntı anlarında ferahlık vesilesidir.',
          target: 33,
          category: 'Günün Zikirleri',
        ),
        DhikrModel(
          id: 'hasbunallah',
          title: 'Hasbünallâhu ve Ni\'mel Vekîl',
          arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
          meaning: 'Allah bize yeter, O ne güzel vekildir.',
          virtue:
              'Hz. İbrahim ateşe atılırken bu zikri söylemiştir. Korku, kaygı ve zor anlarda en büyük sığınaktır.',
          target: 100,
          category: 'Önemli Dualar',
        ),
        // Esmâ-ül Hüsnâ
        DhikrModel(
          id: 'ya_allah',
          title: 'Yâ Allâh (Celle Celâluhû)',
          arabic: 'يَا اَللَّهُ',
          meaning: 'Kendisinden başka ilah olmayan, tek yaratıcı.',
          virtue: 'İhlas ve yakınlık kazandırır, kalp huzurunu temin eder.',
          target: 66,
          category: 'Esmâ-ül Hüsnâ',
        ),
        DhikrModel(
          id: 'ya_rahman',
          title: 'Yâ Rahmân',
          arabic: 'يَا رَحْمَٰنُ',
          meaning: 'Dünyada bütün mahlukata merhamet eden.',
          virtue: 'Günde 298 defa zikredenin kalbinde şefkat ve merhamet artar.',
          target: 298,
          category: 'Esmâ-ül Hüsnâ',
        ),
        DhikrModel(
          id: 'ya_vedud',
          title: 'Yâ Vedûd',
          arabic: 'يَا وَدُودُ',
          meaning: 'İyiliği ve kullarını çok seven, sevilmeye en layık olan.',
          virtue: 'Gönüller arasında sevgi, saygı ve muhabbetin artmasına vesiledir.',
          target: 20,
          category: 'Esmâ-ül Hüsnâ',
        ),
        DhikrModel(
          id: 'ya_fettah',
          title: 'Yâ Fettâh',
          arabic: 'يَا فَتَّاحُ',
          meaning: 'Bütün hayır ve bereket kapılarını açan, darlıkları gideren.',
          virtue: 'Kapalı kapıların açılması, ferahlık ve işlerin kolaylaşması için çekilir.',
          target: 489,
          category: 'Esmâ-ül Hüsnâ',
        ),
        DhikrModel(
          id: 'ya_rezzak',
          title: 'Yâ Rezzâk',
          arabic: 'يَا رَزَّاقُ',
          meaning: 'Tüm yaratılmışların rızkını veren ve onları doyuran.',
          virtue: 'Maddi ve manevi rızkın bollaşması ve bereket için zikredilir.',
          target: 308,
          category: 'Esmâ-ül Hüsnâ',
        ),
        DhikrModel(
          id: 'ya_safi',
          title: 'Yâ Şâfî',
          arabic: 'يَا شَافِي',
          meaning: 'Maddi ve manevi her türlü hastalığa şifa veren.',
          virtue: 'Hastalık anlarında şifa ve sıhhat niyetiyle çokça zikredilir.',
          target: 391,
          category: 'Esmâ-ül Hüsnâ',
        ),
      ];
}
