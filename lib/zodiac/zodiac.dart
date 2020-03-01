import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tamz/custom_button.dart';
import 'package:tamz/zodiac/zodiac_info_dialog.dart';

var data = <Symbol>[
  Symbol.from(
      name: 'Beran',
      id: 'beran',
      info:
          'Beranům vládne živel ohně a lidé narození v tomto znamení proto překypují životní energií. Jsou průbojní a ambiciózní, když se pro něco nadchnou. Chtěli by mít všechno hned a umí si prosadit to, po čem touží. V životě to mohou díky těmto vlastnostem dotáhnout hodně daleko, ale jako daň za to se často zapletou do sporů a hádek. Provází je až dětská radost ze života, jsou spontánní a bezstarostní.',
      start: DateTime(2020, 3, 20),
      end: DateTime(2020, 4, 21)),
  Symbol.from(
      name: 'Býk',
      id: 'byk',
      info:
          'Býci jsou ovlivňováni živlem země a to jim dává smysl pro praktické a materiální záležitosti. Mají klidnou a vyrovnanou povahu a hlavním smyslem jejich života bývá práce. Když se nadchnou pro nějakou myšlenku, rádi budou tvrdě a neúnavně pracovat na jejím uskutečnění. K životu se staví velmi zodpovědně. Hodně důležité je pro ně hmotné zázemí, rádi se obklopují hezkými věcmi a dokážou ocenit luxus.',
      start: DateTime(2020, 4, 20),
      end: DateTime(2020, 5, 22)),
  Symbol.from(
      name: 'Blíženci',
      id: 'blizenci',
      info:
          'Blíženci jsou lidé vnímavé a přizpůsobivé povahy a intelektuálního založení. Tito idealisté si libují ve filosofii a baví je zkoumat názory jiných lidí. Mohou se pochlubit širokým okruhem zájmů a žijí činorodým a aktivním životem. Jejich myšlenky a pocity se pohybují závratnou rychlostí a mají vynikající komunikační schopnosti. Jsou to lidé živlu vzduchu a ukrývají se v nich dvě různé osobnosti.',
      start: DateTime(2020, 5, 21),
      end: DateTime(2020, 6, 22)),
  Symbol.from(
      name: 'Rak',
      id: 'rak',
      info:
          'Vodní živel propůjčuje Rakům velkou citlivost a vnímavost. Jsou to emocionálně založení lidé, ale rozhodně jim nechybí jak logické uvažování, tak analytické schopnosti. Díky své empatii se vždy snaží pomáhat slabším, ale přesto je potěší, když se jim povede získat si respekt za svůj vlastní názor. Mají velmi vyvinutý cit pro mezilidské vztahy. V životě si zakládají na rodině, domovu a tradicích.',
      start: DateTime(2020, 6, 21),
      end: DateTime(2020, 7, 23)),
  Symbol.from(
      name: 'Lev',
      id: 'lev',
      info:
          'Zrozenci ve znamení Lva jsou rodilými vůdci, kteří jsou předurčeni k pozicím, kde mohou uplatnit svoji přirozenou autoritu. Jsou to charismatické osobnosti stvořené k tomu, aby stály v centru pozornosti, a to v tom nejlepším slova smyslu. V kariéře jim velmi pomáhá organizační a diplomatický talent. Rádi se chlubí svými úspěchy a kritiku nenesou právě nejlépe. Jsou to však velmi dobrosrdeční lidé.',
      start: DateTime(2020, 7, 22),
      end: DateTime(2020, 8, 23)),
  Symbol.from(
      name: 'Panna',
      id: 'panna',
      info:
          'Lidé narozeni v zemském znamení Panny jsou obdařeni pečlivostí, logickým myšlením a trpělivostí. Jsou pracovití a mají velký smysl pro detail. Jsou to spíš realisté než snílci, stojí nohama pevně na zemi. Mají sklon k perfekcionismu a k věcem se staví kriticky. Často je najdeme v pečovatelských pozicích, rádi pomáhají ostatním a velmi důležité pro ně bývá zdraví, čistota a pořádek ve všem, co dělají.',
      start: DateTime(2020, 8, 22),
      end: DateTime(2020, 9, 23)),
  Symbol.from(
      name: 'Váhy',
      id: 'vahy',
      info:
          'Váhy jsou intelektuálně založení lidé jemné povahy a ovládá je znamení vzduchu. V životě usilují o harmonii a soulad a mají buňky pro umění, často bývají sami velmi tvořiví. Mají smysl pro férovou hru. V každé své činnosti usilují o klid a rovnováhu, spěchu a stresu se vyhýbají. Z toho pramení jejich příslovečná nerozhodnost. Často si nemohou vybrat mezi protichůdnými názory a hledají kompromisy.',
      start: DateTime(2020, 9, 22),
      end: DateTime(2020, 10, 24)),
  Symbol.from(
      name: 'Štír',
      id: 'stir',
      info:
          'Štíři jsou pod vládou vodního živlu a vody jejich duše jsou hluboké. Na první pohled působí pasivně a nenápadně, ale skrývají v sobě dost energie. Vždy si rádi počkají na správnou chvíli a dokážou čekat dlouho. Mají silnou vůli a vřelé city. Není snadné je vyvést z míry, ale na staré křivdy nezapomínají a umí je oplatit. Mají silně vyvinutou intuici, přísný úsudek a vrozený psychologický talent.',
      start: DateTime(2020, 10, 23),
      end: DateTime(2020, 11, 23)),
  Symbol.from(
      name: 'Střelec',
      info:
          'Ohnivé znamení Střelce vyniká svým idealismem a upřímností. Jeho zrozenci se dívají do dálky za velkými ideály a jejich život bývá aktivní a dobrodružný. Udělají hodně pro to, aby se mohli věnovat tomu, čemu věří a co je baví. Důležitá je svoboda. Jsou upřímní a v každé situaci pravdomluvní, intriky jsou Střelcům cizí a občas je někdo může nařknout z nedostatku taktu. Touží po pravdě a poznání.',
      start: DateTime(2020, 11, 22),
      end: DateTime(2020, 12, 22)),
  Symbol.from(
      name: 'Kozoroh',
      id: 'kozoroh',
      info:
          'Pro Kozorohy je typická ambiciózní a cílevědomá povaha. Toto znamení je pod vládou živlu Země, úspěch je pro jeho zrozence velmi důležitý. Touží po uznání. Myslí dlouhodobě a dokážou se pro své cíle ledasčeho příjemného zříct. Jsou spolehliví a odpovědní. Svou povahou jsou introverti a hloubky jejich duše zná jen pár blízkých přátel, před ostatními skrývají své zranitelné nitro pod pevnou slupkou.',
      start: DateTime(2020, 12, 21),
      end: DateTime(2021, 1, 21)),
  Symbol.from(
      name: 'Vodnář',
      id: 'vodnar',
      info:
          'Vodnáře jen tak snadno nepřehlédnete, rádi plavou proti proudu a mívají velmi originální myšlenky a neobvyklý životní styl. Největšími hodnotami pro tyto zvláštní osobnosti je svoboda a přátelství a jejich myšlení je o krok napřed oproti své době. Pro své idealistické názory se často potýkají s nepochopením. Vodnáři jsou pod vládou živlu vzduchu, jenž jim dává bystré myšlení a touhu šířit poznání.',
      start: DateTime(2020, 1, 20),
      end: DateTime(2020, 2, 21)),
  Symbol.from(
      name: 'Ryby',
      id: 'ryby',
      info:
          'Lidé narozeni pod vládou vodního znamení Ryb jsou jemné a klidné povahy a duchovního založení. Nadevše si cení harmonii a mají mimořádně silně vyvinutou intuici. Často vidí věci, které zůstávají jejich okolí skryté. Ryby jsou citlivé a vnímavé bytosti, které rády pomáhají ostatním. Ve společnosti jsou přizpůsobivé a drží se raději v pozadí. Vlastní názor jim nechybí, ale nechávají si ho pro sebe.',
      start: DateTime(2020, 2, 20),
      end: DateTime(2020, 3, 21)),
];

class Zodiac extends StatefulWidget {
  @override
  _ZodiacState createState() => _ZodiacState();
}

class _ZodiacState extends State<Zodiac> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final symbol = data.singleWhere((element) =>
        _selected.isBefore(
            DateTime(_selected.year, element.endMonth, element.endDay)) &&
        _selected.isAfter(
            DateTime(_selected.year, element.startMonth, element.startDay)));
    final index = data.indexWhere((element) =>
        _selected.isBefore(
            DateTime(_selected.year, element.endMonth, element.endDay)) &&
        _selected.isAfter(
            DateTime(_selected.year, element.startMonth, element.startDay)));
    return Scaffold(
      appBar: AppBar(title: Text('Zodiac')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomButton(
                onPressed: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: _selected,
                      firstDate: DateTime.utc(1900, 0, 0),
                      lastDate: DateTime.now());
                  if (date != null) {
                    setState(() {
                      _selected = date;
                    });
                  }
                },
                text:
                    '${_selected.day} / ${_selected.month} / ${_selected.year}',
                big: true),
            InkWell(
              onTap: () => showDialog(
                  context: context,
                  child: ZodiacInfoDialog(
                    symbol: symbol,
                    date: _selected,
                  )),
              child: Image.asset('assets/zodiac/$index.png',
                  width: MediaQuery.of(context).size.width * 0.75),
            ),
            Text(
              symbol.name,
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 30),
            )
          ],
        ),
      ),
    );
  }
}
