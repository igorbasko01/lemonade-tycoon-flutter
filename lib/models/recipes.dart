import 'ingredients.dart';
import 'inventory.dart';

class Recipe {
  final String name;
  final List<IngredientAmount> requiredIngredients;
  final Ingredient outputIngredient;

  Recipe({
    required this.name,
    required this.requiredIngredients,
    required this.outputIngredient,
  });

  bool canPrepare(Inventory inventory) {
    for (var ingredientAmount in requiredIngredients) {
      if (inventory.hasIngredient(
            ingredientAmount.ingredient,
            minimumAmount: ingredientAmount.amount,
          ) !=
          HasIngredientResult.found) {
        return false;
      }
    }
    return true;
  }

  bool prepare(Inventory inventory) {
    if (!canPrepare(inventory)) {
      return false;
    }

    // Consume ingredients
    for (var ingredientAmount in requiredIngredients) {
      inventory.withdrawIngredient(ingredientAmount);
    }

    // Add product
    inventory.addIngredient(
      IngredientAmount(ingredient: outputIngredient, amount: 1),
    );

    return true;
  }
}

class Recipes {
  static final Recipe sweetLemonade = Recipe(
    name: 'Sweet Lemonade',
    requiredIngredients: [
      IngredientAmount(ingredient: Ingredients.lemon, amount: 1),
      IngredientAmount(ingredient: Ingredients.sugar, amount: 4),
      IngredientAmount(ingredient: Ingredients.water, amount: 1),
    ],
    outputIngredient: Ingredient(name: 'Sweet Lemonade'),
  );

  static final Recipe mildLemonade = Recipe(
    name: 'Mild Lemonade',
    requiredIngredients: [
      IngredientAmount(ingredient: Ingredients.lemon, amount: 2),
      IngredientAmount(ingredient: Ingredients.sugar, amount: 2),
      IngredientAmount(ingredient: Ingredients.water, amount: 1),
    ],
    outputIngredient: Ingredient(name: 'Mild Lemonade'),
  );

  static final Recipe refreshingLemonade = Recipe(
    name: 'Refreshing Lemonade',
    requiredIngredients: [
      IngredientAmount(ingredient: Ingredients.lemon, amount: 1),
      IngredientAmount(ingredient: Ingredients.sugar, amount: 1),
      IngredientAmount(ingredient: Ingredients.ice, amount: 2),
      IngredientAmount(ingredient: Ingredients.water, amount: 1),
    ],
    outputIngredient: Ingredient(name: 'Refreshing Lemonade'),
  );

  static List<Recipe> get all => [
    sweetLemonade,
    mildLemonade,
    refreshingLemonade,
  ];
}
