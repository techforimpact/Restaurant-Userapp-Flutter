// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FoodModel {
   String name;
   double price;
   double weight;
   double calory;
   double protein;
   String item;
   String imgPath;
  FoodModel({
    required this.name,
    required this.price,
    required this.weight,
    required this.calory,
    required this.protein,
    required this.item,
    required this.imgPath,
  });




  FoodModel copyWith({
    String? name,
    double? price,
    double? weight,
    double? calory,
    double? protein,
    String? item,
    String? imgPath,
  }) {
    return FoodModel(
      name: name ?? this.name,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      calory: calory ?? this.calory,
      protein: protein ?? this.protein,
      item: item ?? this.item,
      imgPath: imgPath ?? this.imgPath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'weight': weight,
      'calory': calory,
      'protein': protein,
      'item': item,
      'imgPath': imgPath,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['name'] as String,
      price: map['price'] as double,
      weight: map['weight'] as double,
      calory: map['calory'] as double,
      protein: map['protein'] as double,
      item: map['item'] as String,
      imgPath: map['imgPath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) => FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FoodModel(name: $name, price: $price, weight: $weight, calory: $calory, protein: $protein, item: $item, imgPath: $imgPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FoodModel &&
      other.name == name &&
      other.price == price &&
      other.weight == weight &&
      other.calory == calory &&
      other.protein == protein &&
      other.item == item &&
      other.imgPath == imgPath;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      calory.hashCode ^
      protein.hashCode ^
      item.hashCode ^
      imgPath.hashCode;
  }
    static List<FoodModel> list = [
    FoodModel(
      name: "Doppio Zero Burger",
      price: 120,
      weight: 130,
      calory: 460,
      protein: 30,
      item:
      "#Chicken #Juicy BBQ #Vegetables #Potato Wedges #Coleslaw Salad #Healthy Yolk #Spicy Fries #Mushroom",
      imgPath: "1.png",
    ),
    FoodModel(
      name: "Traditional Beef Lasagne",
      price: 100,
      weight: 120,
      calory: 300,
      protein: 45,
      item:
      "#Beef ragù, #béchamel sauce, #lasagne, #Napoletana, #mozzarella & #parmesan.",
      imgPath: "2d.png",
    ),
    FoodModel(
      name: "Roast Seasonal Vegetables",
      price: 90,
      weight: 100,
      calory: 320,
      protein: 150,
      item:
      "#Seasonal vegetables, #herbs, #oil, #seasoning",
      imgPath: "3d.png",
    ),
    FoodModel(
      name: "Creamy Mashed Potato",
      price: 50,
      weight: 30,
      calory: 65,
      protein: 50,
      item:
      "#Potato, #cream, #butter, #seasoning.",
      imgPath: "4d.png",
    ),
    FoodModel(
      name: "Tortellini Ai Fromaggi",
      price: 20,
      weight: 30,
      calory: 120,
      protein: 310,
      item:
      "#Cheese #Tortellini tossed in a creamy four cheese sauce.",
      imgPath: "5d.png",
    ),
    FoodModel(
      name: "Spaghetti Bolognese",
      price: 20,
      weight: 30,
      calory: 120,
      protein: 310,
      item:
      "#Beef ragu tossed with spaghetti.",
      imgPath: "6d.png",
    ),
    FoodModel(
      name: "Fresh Pasta Sauce – Parmesan Cream (1kg)",
      price: 95,
      weight: 30,
      calory: 120,
      protein: 310,
      item:
      "#Parmesan Cream – milk, #cream, #parmesan, #butter, #flour, #seasoning.  #Basil Pesto: #Basil, #oil, #parmesan, #nuts.",
      imgPath: "7d.png",
    ),
    FoodModel(
      name: "Fresh Pasta Sauce – Napoli (1kg)",
      price: 75,
      weight: 30,
      calory: 120,
      protein: 310,
      item:
      "#Napoli – tomatoes, #onion, #celery, #carrot, #basil, #cream.",
      imgPath: "8d.png",
    ),
    FoodModel(
      name: "Caesar Salad",
      price: 135,
      weight: 30,
      calory: 120,
      protein: 310,
      item:
      "#Cos lettuce, #bacon bits, #shaved parmesan, #creamy anchovy dressing & croutons.",
      imgPath: "9d.png",
    ),
  ];

}
 