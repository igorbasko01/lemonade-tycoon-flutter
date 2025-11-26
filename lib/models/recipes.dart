import 'ingredients.dart';

class Recipe {
    final String name;
    final List<IngredientAmount> requiredIngredients;
    final Ingredient outputIngredient;

    Recipe({required this.name, required this.requiredIngredients, required this.outputIngredient});

    Ingredient prepare() {
        return outputIngredient;
    }
}