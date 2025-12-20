class Product {
  String id;
  String sku;
  String name;
  String price;
  String quantity;
  String description;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
  });

  // Conersion d'un Prodeuit a  partie 'un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'price': price,
      'quantity': quantity,
      'description': description,
    };
  }

  // Creatio d'une tache a  aprtir d'une Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      sku: map['sku'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
      description: map['description'],
    );
  }

  // Methode pour copier un User aveec certaines valeurs modifiees
  Product copyWith({
    String? id,
    String? sku,
    String? name,
    String? price,
    String? quantity,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, sku: $sku, name: $name, price: $price, quantity: $quantity, deescription: $description}';
  }
}
