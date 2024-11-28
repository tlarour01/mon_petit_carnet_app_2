import { useParams, useNavigate } from 'react-router-dom';
import { useLiveQuery } from 'dexie-react-hooks';
import { db, deleteRecipe } from '../db/db';
import { ShareIcon, TrashIcon } from '@heroicons/react/24/outline';

export default function RecipeDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const recipe = useLiveQuery(() => db.recipes.get(Number(id)));

  if (!recipe) return <div>Loading...</div>;

  const handleShare = async () => {
    const recipeText = `
${recipe.title}
by ${recipe.author}

${recipe.description}

Ingredients:
${recipe.ingredients.map(i => `• ${i}`).join('\n')}

Steps:
${recipe.steps.map((s, i) => `${i + 1}. ${s}`).join('\n')}
    `;

    try {
      await navigator.share({
        title: recipe.title,
        text: recipeText,
      });
    } catch (error) {
      // Fallback to clipboard
      await navigator.clipboard.writeText(recipeText);
      alert('Recipe copied to clipboard!');
    }
  };

  const handleDelete = async () => {
    if (window.confirm('Are you sure you want to delete this recipe?')) {
      await deleteRecipe(Number(id));
      navigate('/');
    }
  };

  return (
    <div className="max-w-2xl mx-auto">
      <div className="flex justify-between items-start mb-6">
        <div>
          <h1 className="text-3xl font-bold mb-2">{recipe.title}</h1>
          <p className="text-gray-600">By {recipe.author}</p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={handleShare}
            className="bg-green-600 text-white px-4 py-2 rounded-md flex items-center"
          >
            <ShareIcon className="h-5 w-5 mr-2" />
            Share
          </button>
          <button
            onClick={handleDelete}
            className="bg-red-600 text-white px-4 py-2 rounded-md flex items-center"
          >
            <TrashIcon className="h-5 w-5 mr-2" />
            Delete
          </button>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-md p-6 mb-6">
        <p className="text-gray-700 mb-6">{recipe.description}</p>

        <h2 className="text-xl font-semibold mb-4">Ingredients</h2>
        <ul className="list-disc list-inside mb-6">
          {recipe.ingredients.map((ingredient, index) => (
            <li key={index} className="text-gray-700 mb-2">{ingredient}</li>
          ))}
        </ul>

        <h2 className="text-xl font-semibold mb-4">Steps</h2>
        <ol className="list-decimal list-inside">
          {recipe.steps.map((step, index) => (
            <li key={index} className="text-gray-700 mb-4">{step}</li>
          ))}
        </ol>
      </div>
    </div>
  );
}