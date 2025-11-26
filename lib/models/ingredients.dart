class Ingredient {
    final String name;

    Ingredient({required this.name});
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