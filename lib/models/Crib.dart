class Crib {
  String id;
  String? name;
  List<Access> access;
  STATUS status = STATUS.INACTIVE;
  String? ipaddress;
  String? wifissid;

  Crib({
    required this.id,
    required this.access,
    this.status = STATUS.INACTIVE,
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
          (element) => element.toString() == json['status'],
          orElse: () => STATUS.INACTIVE),
      ipaddress: json['ipaddress'],
      wifissid: json['wifissid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'access': access.map((e) => e.toJson()).toList(),
      'status': status.name,
      'ipaddress': ipaddress,
      'wifissid': wifissid,
    };
  }
}

enum STATUS {
  ACTIVE,
  INACTIVE,
}

class Access {
  ACCESSSTATUS status;
  String user;
  bool? accepted;

  Access({
    required this.status,
    required this.user,
    this.accepted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'user': user,
      'accepted': accepted,
    };
  }

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      status: ACCESSSTATUS.values
          .firstWhere((element) => element.toString() == json['status']),
      user: json['user'],
      accepted: json['accepted'],
    );
  }
}

enum ACCESSSTATUS {
  ADMIN,
  OPERATOR,
}
