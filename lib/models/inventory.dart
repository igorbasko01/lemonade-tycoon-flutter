import 'ingredients.dart';

enum WithdrawalResult { success, insufficientAmount, ingredientNotFound }

enum HasIngredientResult { found, notFound, insufficientAmount }

class Inventory {
  final Map<Ingredient, int> ingredients;

  Inventory({required this.ingredients});

  HasIngredientResult hasIngredient(
    Ingredient ingredient, {
    int minimumAmount = 1,
  }) {
    if (!ingredients.containsKey(ingredient)) {
      return HasIngredientResult.notFound;
    }
    if (ingredients[ingredient]! < minimumAmount) {
      return HasIngredientResult.insufficientAmount;
    }
    return HasIngredientResult.found;
  }

  void addIngredient(IngredientAmount ingredient) {
    ingredients.update(
      ingredient.ingredient,
      (current) => current + ingredient.amount,
      ifAbsent: () => ingredient.amount,
    );
  }

  WithdrawalResult withdrawIngredient(IngredientAmount ingredient) {
    final hasResult = hasIngredient(
      ingredient.ingredient,
      minimumAmount: ingredient.amount,
    );
    if (hasResult == HasIngredientResult.notFound) {
      return WithdrawalResult.ingredientNotFound;
    } else if (hasResult == HasIngredientResult.insufficientAmount) {
      return WithdrawalResult.insufficientAmount;
    } else {
      ingredients[ingredient.ingredient] =
          ingredients[ingredient.ingredient]! - ingredient.amount;
      return WithdrawalResult.success;
    }
  }
}
