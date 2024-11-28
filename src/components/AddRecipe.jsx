import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { addRecipe } from '../db/db';

export default function AddRecipe() {
  const navigate = useNavigate();
  const [recipe, setRecipe] = useState({
    title: '',
    author: '',
    description: '',
    ingredients: [''],
    steps: [''],
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    await addRecipe(recipe);
    navigate('/');
  };

  const addField = (field) => {
    setRecipe({
      ...recipe,
      [field]: [...recipe[field], ''],
    });
  };

  const updateField = (field, index, value) => {
    const newArray = [...recipe[field]];
    newArray[index] = value;
    setRecipe({
      ...recipe,
      [field]: newArray,
    });
  };

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Add New Recipe</h1>
      <form onSubmit={handleSubmit} className="space-y-6">
        <div>
          <label className="block text-sm font-medium text-gray-700">Title</label>
          <input
            type="text"
            required
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
            value={recipe.title}
            onChange={(e) => setRecipe({ ...recipe, title: e.target.value })}
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Author</label>
          <input
            type="text"
            required
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
            value={recipe.author}
            onChange={(e) => setRecipe({ ...recipe, author: e.target.value })}
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Description</label>
          <textarea
            required
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
            rows="3"
            value={recipe.description}
            onChange={(e) => setRecipe({ ...recipe, description: e.target.value })}
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Ingredients</label>
          {recipe.ingredients.map((ingredient, index) => (
            <div key={index} className="flex gap-2 mb-2">
              <input
                type="text"
                required
                className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
                value={ingredient}
                onChange={(e) => updateField('ingredients', index, e.target.value)}
                placeholder={`Ingredient ${index + 1}`}
              />
            </div>
          ))}
          <button
            type="button"
            onClick={() => addField('ingredients')}
            className="text-green-600 hover:text-green-700"
          >
            + Add Ingredient
          </button>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Steps</label>
          {recipe.steps.map((step, index) => (
            <div key={index} className="flex gap-2 mb-2">
              <textarea
                required
                className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
                value={step}
                onChange={(e) => updateField('steps', index, e.target.value)}
                placeholder={`Step ${index + 1}`}
                rows="2"
              />
            </div>
          ))}
          <button
            type="button"
            onClick={() => addField('steps')}
            className="text-green-600 hover:text-green-700"
          >
            + Add Step
          </button>
        </div>

        <div className="flex justify-end">
          <button
            type="submit"
            className="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700"
          >
            Save Recipe
          </button>
        </div>
      </form>
    </div>
  );
}