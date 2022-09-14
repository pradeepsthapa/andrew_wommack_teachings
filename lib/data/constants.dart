import 'package:google_fonts/google_fonts.dart';
import 'font_model.dart';

class Constants {

  static const String pageIndex = 'pageIndex';
  static const String darkMode = 'darkMode';
  static const String fontSize = 'fontSize';
  static const String backgroundColor = 'background';
  static const String fontIndex = 'fontStyle';
  static const String bibleIndex = 'bibleIndex';
  static const String chapterIndex = 'chapterIndex';
  static const String showCommentary = 'showCommentary';
  static const String showReferences = 'showReferences';
  static const String currentBible = 'currentBible';
  static const String bookmarks = 'bookmarks';
  static const String downloadState = 'downloads';

  static List<GlobalFontModel> globalFonts = [
    GlobalFontModel(textTheme: GoogleFonts.breeSerifTextTheme(), fontFamily: GoogleFonts.breeSerif().fontFamily!, fontName: "Bree Seriff"),
    GlobalFontModel(textTheme: GoogleFonts.cabinTextTheme(), fontFamily: GoogleFonts.cabin().fontFamily!, fontName: "Cabin"),
    GlobalFontModel(textTheme: GoogleFonts.openSansTextTheme(), fontFamily: GoogleFonts.openSans().fontFamily!, fontName: "Open Sans"),
    GlobalFontModel(textTheme: GoogleFonts.playfairDisplayTextTheme(), fontFamily: GoogleFonts.playfairDisplay().fontFamily!, fontName: "Playfair Display"),
    GlobalFontModel(textTheme: GoogleFonts.alegreyaSansTextTheme(), fontFamily: GoogleFonts.alegreyaSans().fontFamily!, fontName: "Alegreya Sans"),
    GlobalFontModel(textTheme: GoogleFonts.ubuntuTextTheme(), fontFamily: GoogleFonts.ubuntu().fontFamily!, fontName: "Ubuntu"),
    GlobalFontModel(textTheme: GoogleFonts.crimsonProTextTheme(), fontFamily: GoogleFonts.crimsonPro().fontFamily!, fontName: "Crimson Pro"),
    GlobalFontModel(textTheme: GoogleFonts.lobsterTwoTextTheme(), fontFamily: GoogleFonts.lobsterTwo().fontFamily!, fontName: "Lobster Two"),
    GlobalFontModel(textTheme: GoogleFonts.sueEllenFranciscoTextTheme(), fontFamily: GoogleFonts.sueEllenFrancisco().fontFamily!, fontName: "Sue Ellen Francisco"),
    GlobalFontModel(textTheme: GoogleFonts.comfortaaTextTheme(), fontFamily: GoogleFonts.comfortaa().fontFamily!, fontName: "Comfortaa"),
    GlobalFontModel(textTheme: GoogleFonts.spaceMonoTextTheme(), fontFamily: GoogleFonts.spaceMono().fontFamily!, fontName: "Space Mono"),
    GlobalFontModel(textTheme: GoogleFonts.sansitaTextTheme(), fontFamily: GoogleFonts.sansita().fontFamily!, fontName: "Sansita"),
    GlobalFontModel(textTheme: GoogleFonts.oldStandardTtTextTheme(), fontFamily: GoogleFonts.oldStandardTt().fontFamily!, fontName: "Old Standard TT"),
    GlobalFontModel(textTheme: GoogleFonts.heeboTextTheme(), fontFamily: GoogleFonts.heebo().fontFamily!, fontName: "Heebo"),
    GlobalFontModel(textTheme: GoogleFonts.literataTextTheme(), fontFamily: GoogleFonts.literata().fontFamily!, fontName: "Literata"),
    GlobalFontModel(textTheme: GoogleFonts.sourceSansProTextTheme(), fontFamily: GoogleFonts.sourceSansPro().fontFamily!, fontName: "Source Sans Pro"),
    GlobalFontModel(textTheme: GoogleFonts.ibmPlexSansTextTheme(), fontFamily: GoogleFonts.ibmPlexSans().fontFamily!, fontName: "IBM Plex"),
    GlobalFontModel(textTheme: GoogleFonts.merriweatherTextTheme(), fontFamily: GoogleFonts.merriweather().fontFamily!, fontName: "Merriweather"),
    GlobalFontModel(textTheme: GoogleFonts.notoSerifTextTheme(), fontFamily: GoogleFonts.notoSerif().fontFamily!, fontName: "Noto Serif"),
    GlobalFontModel(textTheme: GoogleFonts.libreBaskervilleTextTheme(), fontFamily: GoogleFonts.libreBaskerville().fontFamily!, fontName: "Libre Baskerville"),
    GlobalFontModel(textTheme: GoogleFonts.quicksandTextTheme(), fontFamily: GoogleFonts.quicksand().fontFamily!, fontName: "Quicksand"),
    GlobalFontModel(textTheme: GoogleFonts.loraTextTheme(), fontFamily: GoogleFonts.lora().fontFamily!, fontName: "Lora"),
    GlobalFontModel(textTheme: GoogleFonts.montserratTextTheme(), fontFamily: GoogleFonts.montserrat().fontFamily!, fontName: "Montserrat"),
    GlobalFontModel(textTheme: GoogleFonts.workSansTextTheme(), fontFamily: GoogleFonts.workSans().fontFamily!, fontName: "Work Sans"),
    GlobalFontModel(textTheme: GoogleFonts.slabo13pxTextTheme(), fontFamily: GoogleFonts.slabo13px().fontFamily!, fontName: "Slabo 13px"),
  ];
}