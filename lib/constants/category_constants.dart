// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Category {
  String name, imgPath;
  Color begin, end;
  List<String> subCategory;
  Category(
      {required this.imgPath,
      required this.end,
      required this.subCategory,
      required this.begin,
      required this.name});
}

const List<String> VehiclesSub = [
  " Cars",
  "Motorcycles",
  " Accessories & Parts"
];

const List<String> PropertySub = ["Properties For Sale", "Properties For Rent"];

const List<String> ElectronicSub = [
  "Mobile Phones",
  "Tablets",
  "Mobile Gadget Accessories",
  " Wearables & Smart Watches",
  " Laptops",
  "Desktops",
  " Computer Accessories",
  " Printers",
  " Cameras",
  " Drones",
  " Photography Accesories",
  "TV",
];

const List<String> Mens_CollectionSub = [
  "Bags & Wallets",
  "Shoes",
  " Watches & Fashion Accessories",
  "Clothes",
  "Healthy & Beatuty",
];
const List<String> Womens_CollectionSub = [
  "Bags & Wallets",
  "Shoes",
  " Watches & Fashion Accessories",
  "Clothes",
  "Healthy & Beatuty",
];
const List<String> Home_And_Personal_ItemsSub = [
  "Bed & Bath",
  "Home Appliances & Kitchen",
  "Furniture & Decoration",
  "Garden Items",
  "Moms & Kids",
];

const List<String> Leisure_Or_Sports_Or_HobbiesSub = [
  "Books/Magazines/Music/Movies",
  "Sports & Outdoors",
  "Textbooks",
  "Hobby & Collectibles",
  "Musical Instruments",
  "Tickets & Vouchers"
];
const List<String> jobSub = ["Part-time", "Full-time", "Internships & Others"];
const List<String> servicesSub = [
  "Home Services",
  "Electronic & Gadgets Repairs",
  "Tuition",
  "Beauty Services"
];
const List<String> foodSub = ["Food", "Beverage"];
List<Category> categoryList = [
  Category(
      begin: const Color.fromARGB(255, 88, 217, 227),
      end: const Color.fromARGB(255, 3, 79, 175),
      name: "Vehicles",
      imgPath: "assets/images/category/transparent/vehicle.png",
      subCategory: VehiclesSub),
  Category(
      begin: const Color.fromARGB(255, 255, 246, 173),
      end: const Color.fromARGB(255, 255, 175, 242),
      name: "Property",
      imgPath: "assets/images/category/transparent/property.png",
      subCategory: PropertySub),
  Category(
      begin: const Color.fromARGB(255, 204, 253, 216),
      end: const Color.fromARGB(255, 149, 186, 254),
      name: "Electronic",
      imgPath: "assets/images/category/transparent/electronic.png",
      subCategory: ElectronicSub),
  Category(
      begin: const Color.fromARGB(255, 16, 192, 220),
      end: const Color.fromARGB(255, 251, 221, 90),
      name: "Men's Collection",
      imgPath: "assets/images/category/transparent/men fashion.png",
      subCategory: Mens_CollectionSub),
  Category(
      begin: const Color.fromARGB(255, 244, 86, 103),
      end: const Color.fromARGB(255, 146, 82, 245),
      name: "Women's Collection",
      imgPath: "assets/images/category/transparent/women fashion.png",
      subCategory: Womens_CollectionSub),
  Category(
      begin: const Color.fromARGB(255, 89, 111, 252),
      end: const Color.fromARGB(255, 247, 102, 198),
      name: "Home & Personal Items",
      imgPath: "assets/images/category/transparent/washing machine.png",
      subCategory: Womens_CollectionSub),
  Category(
      begin: const Color.fromARGB(255, 175, 175, 175),
      end: const Color.fromARGB(255, 254, 254, 254),
      name: "Leisure/Sports/Hobbies",
      imgPath: "assets/images/category/transparent/sport.png",
      subCategory: Leisure_Or_Sports_Or_HobbiesSub),
  Category(
      begin: const Color.fromARGB(255, 255, 217, 88),
      end: const Color.fromARGB(255, 255, 145, 77),
      name: "Jobs",
      imgPath: "assets/images/category/transparent/job.png",
      subCategory: jobSub),
  Category(
      begin: const Color.fromARGB(255, 16, 12, 1),
      end: const Color.fromARGB(255, 194, 140, 21),
      name: "Services",
      imgPath: "assets/images/category/transparent/services.png",
      subCategory: servicesSub),
  Category(
      begin: const Color.fromARGB(255, 5, 154, 173),
      end: const Color.fromARGB(255, 116, 211, 94),
      name: "Food & Drinks",
      imgPath: "assets/images/category/transparent/food.png",
      subCategory: foodSub),
];
