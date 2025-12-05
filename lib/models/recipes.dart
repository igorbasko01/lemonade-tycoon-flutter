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

  bool prepare(Inventory inventory) {
    // Check if we have enough ingredients
    for (var ingredientAmount in requiredIngredients) {
      if (inventory.hasIngredient(
            ingredientAmount.ingredient,
            minimumAmount: ingredientAmount.amount,
          ) !=
          HasIngredientResult.found) {
        return false;
      }
    }

    // Consume ingredients
    for (var ingredientAmount in requiredIngredients) {
      inventory.withdrawIngredient(ingredientAmount);
    }

    // Add product
    inventory.addIngredient(IngredientAmount(
      ingredient: outputIngredient,
      amount: 1,
    ));

    return true;
  }
}