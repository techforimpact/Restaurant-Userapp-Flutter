import 'package:flutter/material.dart';

class Product {

  final String image, title, description;
  final int price, size, id;
  final Color color;

  Product({
   required this.id,
  required  this.image,
  required  this.title,
  required  this.price,
  required  this.description,
  required  this.size,
  required  this.color,
  });

}

List<Product> products = [
  Product(
    id: 1,
    title: "Office Code",
    price: 74,
    size: 12,
    description: "This is burger",
    image: 'assets/images/burger.png',
    color: const Color(0xFF3D82AE)
  ),
  Product(
      id: 2,
      title: "Office Code 2",
      price: 56,
      size: 12,
      description: "This is mcd",
      image: 'assets/images/mc_d.png',
      color: const Color(0xFF3D82AE)
  ),
  Product(
      id: 3,
      title: "Office Code 3",
      price: 34,
      size: 12,
      description: "this is kfc",
      image: 'assets/images/kfc.png',
      color: const Color(0xFF3D82AE)
  )
];