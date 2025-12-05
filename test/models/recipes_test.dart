import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/recipes.dart';

void main() {
  late Inventory inventory;

  setUp(() {
    inventory = Inventory(ingredients: {
      Ingredients.lemon: 10,
      Ingredients.sugar: 10,
    });
  });

  group('Recipe.prepare', () {
    test('successfully prepares when ingredients exist', () {
      final recipe = Recipe(
        name: 'Lemonade',
        requiredIngredients: [
          IngredientAmount(ingredient: Ingredients.lemon, amount: 2),
          IngredientAmount(ingredient: Ingredients.sugar, amount: 1),
        ],
        outputIngredient: Ingredient(name: 'Lemonade Product'),
      );

      final result = recipe.prepare(inventory);

      expect(result, true);
      expect(inventory.ingredients[Ingredients.lemon], 8);
      expect(inventory.ingredients[Ingredients.sugar], 9);
      expect(inventory.ingredients[recipe.outputIngredient], 1);
    });

    test('fails to prepare when missing ingredients', () {
      final recipe = Recipe(
        name: 'Lemonade',
        requiredIngredients: [
          IngredientAmount(ingredient: Ingredients.lemon, amount: 20), // Need 20, have 10
        ],
        outputIngredient: Ingredient(name: 'Lemonade Product'),
      );

      final result = recipe.prepare(inventory);

      expect(result, false);
      expect(inventory.ingredients[Ingredients.lemon], 10);
    });
  });
}
