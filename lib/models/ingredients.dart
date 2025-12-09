class Ingredient {
  final String name;

  const Ingredient({required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
      runtimeType == other.runtimeType &&
      name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class IngredientAmount {
    final Ingredient ingredient;
    final int amount;

    IngredientAmount({required this.ingredient, required this.amount});
}

class Ingredients {
    static final Ingredient lemon = Ingredient(name: 'lemon');
    static final Ingredient sugar = Ingredient(name: 'sugar');
    static final Ingredient water = Ingredient(name: 'water');
    static final Ingredient ice = Ingredient(name: 'ice');
}