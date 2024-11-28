import Dexie from 'dexie';

export const db = new Dexie('RecipeBook');

db.version(1).stores({
  recipes: '++id, title, author, createdAt',
});

export const addRecipe = async (recipe) => {
  return await db.recipes.add({
    ...recipe,
    createdAt: new Date(),
  });
};

export const getRecipes = async () => {
  return await db.recipes.toArray();
};

export const getRecipe = async (id) => {
  return await db.recipes.get(id);
};

export const deleteRecipe = async (id) => {
  return await db.recipes.delete(id);
};

export const updateRecipe = async (id, recipe) => {
  return await db.recipes.update(id, recipe);
};