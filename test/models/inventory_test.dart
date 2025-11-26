import 'package:flutter_test/flutter_test.dart';
import 'package:lemonade_tycoon/models/inventory.dart';
import 'package:lemonade_tycoon/models/ingredients.dart';

void main() {
    group('hasIngredient', () {
        test('returns true when ingredient is in inventory', () {
            final inventory = Inventory(ingredients: {Ingredients.lemon: 1});
            expect(inventory.hasIngredient(Ingredients.lemon), HasIngredientResult.found);
        });
        test('returns false when ingredient is not in inventory', () {
            final inventory = Inventory(ingredients: {});
            expect(inventory.hasIngredient(Ingredients.lemon), HasIngredientResult.notFound);
        });
        test('returns false when ingredient amount is less than minimum amount', () {
            final inventory = Inventory(ingredients: {Ingredients.lemon: 1});
            expect(inventory.hasIngredient(Ingredients.lemon, minimumAmount: 2), HasIngredientResult.insufficientAmount);
        });
    });

    group('addIngredient', () {
        test('adds new ingredient to inventory', () {
            final inventory = Inventory(ingredients: {});
            inventory.addIngredient(IngredientAmount(ingredient: Ingredients.lemon, amount: 2));
            expect(inventory.ingredients[Ingredients.lemon], 2);
        });
        test('increments existing ingredient amount in inventory', () {
            final inventory = Inventory(ingredients: {Ingredients.lemon: 2});
            inventory.addIngredient(IngredientAmount(ingredient: Ingredients.lemon, amount: 3));
            expect(inventory.ingredients[Ingredients.lemon], 5);
        });
    });

    group('withdrawIngredient', () {
        test('withdraws ingredient when sufficient amount is available', () {
            final inventory = Inventory(ingredients: {Ingredients.lemon: 5});
            final result = inventory.withdrawIngredient(IngredientAmount(ingredient: Ingredients.lemon, amount: 3));
            expect(result, WithdrawalResult.success);
            expect(inventory.ingredients[Ingredients.lemon], 2);
        });
        test('does not withdraw ingredient when insufficient amount is available', () {
            final inventory = Inventory(ingredients: {Ingredients.lemon: 2});
            final result = inventory.withdrawIngredient(IngredientAmount(ingredient: Ingredients.lemon, amount: 3));
            expect(result, WithdrawalResult.insufficientAmount);
            expect(inventory.ingredients[Ingredients.lemon], 2);
        });
        test('does not withdraw ingredient when it is not in inventory', () {
            final inventory = Inventory(ingredients: {});
            final result = inventory.withdrawIngredient(IngredientAmount(ingredient: Ingredients.lemon, amount: 1));
            expect(result, WithdrawalResult.ingredientNotFound);
        });
    });
}