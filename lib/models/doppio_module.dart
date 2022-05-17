
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Doppio {

  String shopName;
  String address;
  String description;
  String thumbnail;
  LatLng locationCoords;


  Doppio({
   required this.shopName,
   required this.address,
   required this.description,
   required this.thumbnail,
   required this.locationCoords
  });

}

  final List<Doppio> doppios = [
    Doppio(
      shopName: "Doppio Zero Rosebank",
      address: "The Firs Shopping Centre Cnr Cradock Street and, Biermann Ave, Rosebank, Johannesburg, 2132",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-13%20at%2002.15.00.png?alt=media&token=52f847e7-463e-4b70-872f-4731a73d7e6a",
      locationCoords: const LatLng(-26.271914, 28.003392),

    ),
    Doppio(
      shopName: "Doppio Zero Hazeldine",
      address: "Shop No.42, Hazeldean Square, Cnr Graham & Silverlakes Rd, Pretoria, 0084",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-13%20at%2002.15.41.png?alt=media&token=64479450-8fb5-4995-a1c3-02549d1ccdd2",
      locationCoords: const LatLng(-25.786200, 28.352450),

    ),
    Doppio(
      shopName: "Doppio Zero Irene",
      address: "52, Southdowns Retail Centre, John Vorster Dr &, Karee St, Irene, Pretoria, 0157",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.10.53.png?alt=media&token=eb8d2f69-401b-4f0b-bbcf-1d31451c895c",
      locationCoords: const LatLng(-25.885880, 28.205650),

    ),
    Doppio(
      shopName: "Doppio Zero Bedfordview",
      address: "Cnr Van Buuren and, Hawley Rd, Bedfordview, Germiston, 2008",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.13.48.png?alt=media&token=665de123-e562-4ecd-8512-fd0a9e72b96c",
      locationCoords: const LatLng(-26.177150, 28.135510),

    ),
    Doppio(
      shopName: "Doppio Zero Bryanston",
      address: "Hobart Grove Centre, 52 Hobart Rd, Bryanston, Sandton, 2191",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.16.09.png?alt=media&token=5c585cff-1036-48cb-9654-a6bc1066bc5f",
      locationCoords: const LatLng(-26.070660, 28.027150),

    ),
    Doppio(
      shopName: "Doppio Zero Blue Hills",
      address: "Cnr. Olifantsfontein Road and Africa, African View Drive, Blue Hills, Midrand, 1685",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.19.26.png?alt=media&token=c3727125-68b5-4df3-8755-b2d15f8af1f5",
      locationCoords: const LatLng(-25.930441, 28.099421),

    ),
    Doppio(
      shopName: "Doppio Zero Cradlestone",
      address: "U91, Hendrik Potgieter Rd &, Furrow Rd, Krugersdorp, 1754",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.36.47.png?alt=media&token=e3fbc3f7-a294-4da9-84ab-91879bd86431",
      locationCoords: const LatLng(-26.062780, 27.840020),

    ),
    Doppio(
      shopName: "Doppio Zero Pineslope",
      address: "Pineslopes Shopping Centre, Witkoppen Rd & The Straight Ave, Pineslopes, Fourways, 2062",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.38.36.png?alt=media&token=7c7be33e-dd38-4669-9ba6-d3420a71b569",
      locationCoords: const LatLng(-26.023310, 28.016350),

    ),
    Doppio(
      shopName: "Doppio Zero Bassonia",
      address: "Shop FF3, Bassonia Shopping Centre, Cnr Comaro Street &, Soetdoring Ave, Bassonia, Johannesburg South, 2061",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.41.31.png?alt=media&token=c6ff2f45-af8f-4207-aae7-b786c1558f24",
      locationCoords: const LatLng(-26.278130, 28.066020),

    ),
    Doppio(
      shopName: "Doppio Zero Bel Air",
      address: "Bel Air Shopping Mall, 2162 Bellairs Dr, Northriding, Randburg, 2162",
      description: "Contemporary cafe chain serving gourmet pizzas, Mediterranean dishes and artisan breads.",
      thumbnail: "https://firebasestorage.googleapis.com/v0/b/foodly-5e1a9.appspot.com/o/Doppios%2FScreenshot%202020-09-14%20at%2007.42.56.png?alt=media&token=afe54bf4-f0a2-46c4-b5c1-564083827127",
      locationCoords: const LatLng(-26.052740, 27.967040),

    ),

  ];
