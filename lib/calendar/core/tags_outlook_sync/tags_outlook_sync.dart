import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';

class TagsOutlookSync {
  const TagsOutlookSync({
    required this.msGraphRepository,
    required this.weeks,
    required this.tags,
  });

  final MSGraphRepository msGraphRepository;
  final List<CalendarWeek> weeks;
  final List<Tag> tags;

  Future<void> call() async {
    // Alle Kalendar fetchen
    // Über alle Tags iterieren
    //  Checken ob Kalendar für Tag existiert -> sonst anlegen
    //  Alle Events fetchen
    //  Nutzer mit Tag in Events mappen
    //  Events, die zu adden sind bestimmen (neu - existiert)
    //  Events, die zu löschen sind bestimmen (existiert - neu)
    //  Events in Batch Request konvertieren
    //  Batch Request hochladen
  }
}
