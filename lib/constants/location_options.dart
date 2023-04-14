List<String> locationOptions = [
  'Whole Malaysia',
  'Johor',
  'Kedah',
  'Kelantan',
  'Malacca',
  'Negeri Sembilan',
  'Pahang',
  'Terengganu',
  'Penang',
  'Perak',
  'Perlis',
  'Sarawak',
  'Sabah',
  'Selangor',
  'Kuala Lumpur',
  'Labuan',
  'PutraJaya'
];
List<String> locationOptionsWithoutWholeMalaysia =
    locationOptions.where((element) => element != 'Whole Malaysia').toList();
