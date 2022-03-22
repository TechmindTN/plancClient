

import 'package:home_services/app/models/Provider.dart';

class Ads {
  final String id;
  final String title;
  final String description;
  final DateTime creation_date;
  final DateTime end_date;
  final int number;
  final int clicks;
  final String media;
  final ServiceProvider provider;
  Ads( 
      { this.id,
       this.provider,
       this.title,
       this.description,
       this.creation_date,
       this.end_date,
       this.number,
       this.clicks,
       this.media});
}
