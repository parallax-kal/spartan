class Crib {
  String id;
  String? name;
  List<Access> access;
  STATUS status;
  String? ipaddress;
  String? wifissid;
  Location location;
  DateTime createdAt;
  List<String> users;

  Crib({
    required this.id,
    required this.access,
    required this.status,
    required this.location,
    required this.createdAt,
    this.users = const [],
    this.name,
    this.ipaddress,
    this.wifissid,
  });

  factory Crib.fromJson(Map<String, dynamic> json) {
    return Crib(
      id: json['id'],
      name: json['name'],
      access: (json['access'] as List<dynamic>)
          .map((e) => Access.fromJson(e))
          .toList(),
      status: STATUS.values.firstWhere(
          (element) => element.name == json['status'],
          orElse: () => STATUS.INACTIVE),
      ipaddress: json['ipaddress'],
      wifissid: json['wifissid'],
      location: Location.fromJson(json['location']),
      users: json['users'].cast<String>(),
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'access': access.map((e) => e.toJson()).toList(),
      'status': status.name,
      'ipaddress': ipaddress,
      'wifissid': wifissid,
      'location': location.toJson(),
      'users': users,
      'createdAt': createdAt,
    };
  }
}

class Location {
  String country;
  String city;
  String latitude;
  String longitude;

  Location({
    required this.country,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

enum STATUS {
  ACTIVE,
  INACTIVE,
}

class Access {
  ACCESSSTATUS? status;
  String user;
  bool? accepted;

  Access({
    this.status,
    required this.user,
    this.accepted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status?.name,
      'user': user,
      'accepted': accepted,
    };
  }

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      status: ACCESSSTATUS.values
          .firstWhere((element) => element.name == json['status']),
      user: json['user'],
      accepted: json['accepted'],
    );
  }
}

enum ACCESSSTATUS {
  ADMIN,
  OPERATOR,
  GUEST,
}
