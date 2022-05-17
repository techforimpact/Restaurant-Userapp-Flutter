// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class Name {
  String name;
  String address;
  DateTime closeTime;
  double commission;
  String emaill;
  String id;
  String image;
  bool isActive;
  double lat;
  double lng;
  DateTime openTime;
  int phone;
  bool popular;
  String role;
  String search_key;
  double total_rates; 
  String uid_id;
  String website_address;
  Name({
    required this.name,
    required this.address,
    required this.closeTime,
    required this.commission,
    required this.emaill,
    required this.id,
    required this.image,
    required this.isActive,
    required this.lat,
    required this.lng,
    required this.openTime,
    required this.phone,
    required this.popular,
    required this.role,
    required this.search_key,
    required this.total_rates,
    required this.uid_id,
    required this.website_address,
  });
  

  Name copyWith({
    String? name,
    String? address,
    DateTime? closeTime,
    double? commission,
    String? emaill,
    String? id,
    String? image,
    bool? isActive,
    double? lat,
    double? lng,
    DateTime? openTime,
    int? phone,
    bool? popular,
    String? role,
    String? search_key,
    double? total_rates,
    String? uid_id,
    String? website_address,
  }) {
    return Name(
      name: name ?? this.name,
      address: address ?? this.address,
      closeTime: closeTime ?? this.closeTime,
      commission: commission ?? this.commission,
      emaill: emaill ?? this.emaill,
      id: id ?? this.id,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      openTime: openTime ?? this.openTime,
      phone: phone ?? this.phone,
      popular: popular ?? this.popular,
      role: role ?? this.role,
      search_key: search_key ?? this.search_key,
      total_rates: total_rates ?? this.total_rates,
      uid_id: uid_id ?? this.uid_id,
      website_address: website_address ?? this.website_address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'closeTime': closeTime.millisecondsSinceEpoch,
      'commission': commission,
      'emaill': emaill,
      'id': id,
      'image': image,
      'isActive': isActive,
      'lat': lat,
      'lng': lng,
      'openTime': openTime.millisecondsSinceEpoch,
      'phone': phone,
      'popular': popular,
      'role': role,
      'search_key': search_key,
      'total_rates': total_rates,
      'uid_id': uid_id,
      'website_address': website_address,
    };
  }

  factory Name.fromMap(Map<String, dynamic> map) {
    return Name(
      name: map['name'] as String,
      address: map['address'] as String,
      closeTime: DateTime.fromMillisecondsSinceEpoch(map['closeTime'] as int),
      commission: map['commission'] as double,
      emaill: map['emaill'] as String,
      id: map['id'] as String,
      image: map['image'] as String,
      isActive: map['isActive'] as bool,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      openTime: DateTime.fromMillisecondsSinceEpoch(map['openTime'] as int),
      phone: map['phone'] as int,
      popular: map['popular'] as bool,
      role: map['role'] as String,
      search_key: map['search_key'] as String,
      total_rates: map['total_rates'] as double,
      uid_id: map['uid_id'] as String,
      website_address: map['website_address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Name.fromJson(String source) => Name.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Name(name: $name, address: $address, closeTime: $closeTime, commission: $commission, emaill: $emaill, id: $id, image: $image, isActive: $isActive, lat: $lat, lng: $lng, openTime: $openTime, phone: $phone, popular: $popular, role: $role, search_key: $search_key, total_rates: $total_rates, uid_id: $uid_id, website_address: $website_address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Name &&
      other.name == name &&
      other.address == address &&
      other.closeTime == closeTime &&
      other.commission == commission &&
      other.emaill == emaill &&
      other.id == id &&
      other.image == image &&
      other.isActive == isActive &&
      other.lat == lat &&
      other.lng == lng &&
      other.openTime == openTime &&
      other.phone == phone &&
      other.popular == popular &&
      other.role == role &&
      other.search_key == search_key &&
      other.total_rates == total_rates &&
      other.uid_id == uid_id &&
      other.website_address == website_address;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      address.hashCode ^
      closeTime.hashCode ^
      commission.hashCode ^
      emaill.hashCode ^
      id.hashCode ^
      image.hashCode ^
      isActive.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      openTime.hashCode ^
      phone.hashCode ^
      popular.hashCode ^
      role.hashCode ^
      search_key.hashCode ^
      total_rates.hashCode ^
      uid_id.hashCode ^
      website_address.hashCode;
  }
}
