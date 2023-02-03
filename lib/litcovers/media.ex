defmodule Litcovers.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias Litcovers.Metadata
  alias Litcovers.Accounts
  alias Litcovers.Repo

  alias Litcovers.Media.Image

  def unlock_image(%Image{} = image) do
    image
    |> Image.unlocked_changeset(%{unlocked: true})
    |> Repo.update()
  end

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images do
    Repo.all(Image)
  end

  def list_unlocked_user_images(%Accounts.User{} = user) do
    Image
    |> user_requests_query(user)
    |> order_by_date_insert()
    |> completed_query()
    |> unlocked_query()
    |> Repo.all()
  end

  def list_user_images(%Accounts.User{} = user) do
    Image
    |> user_requests_query(user)
    |> order_by_date_insert()
    |> completed_query()
    |> Repo.all()
  end

  def list_user_favorite_images(%Accounts.User{} = user) do
    Image
    |> user_requests_query(user)
    |> order_by_date_insert()
    |> completed_query()
    |> unlocked_query()
    |> favorite_query()
    |> Repo.all()
  end

  # defp limit_query(query, limit) do
  #   from(r in query, limit: ^limit)
  # end

  defp order_by_date_insert(query) do
    from(r in query, order_by: [desc: r.inserted_at])
  end

  defp completed_query(query) do
    from(r in query, where: r.completed == true)
  end

  defp favorite_query(query) do
    from(r in query, where: r.favorite == true)
  end

  defp user_requests_query(query, %Accounts.User{id: user_id}) do
    from(r in query, where: r.user_id == ^user_id)
  end

  defp unlocked_query(query) do
    from(r in query, where: r.unlocked == true)
  end

  def user_images_amount(%Accounts.User{} = user) do
    Image
    |> user_requests_query(user)
    |> Repo.aggregate(:count)
  end

  def user_unlocked_images_amount(%Accounts.User{} = user) do
    Image
    |> user_requests_query(user)
    |> unlocked_query()
    |> Repo.aggregate(:count)
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Image, id)

  def get_image_preload!(id) do
    Image
    |> Repo.get!(id)
    |> Repo.preload([:user, :prompt])
  end

  def get_image_preload_all!(id) do
    Image
    |> Repo.get!(id)
    |> Repo.preload([:user, :prompt, :ideas])
  end

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(%Accounts.User{} = user, %Metadata.Prompt{} = prompt, attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:prompt, prompt)
    |> Repo.insert()
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{data: %Image{}}

  """
  def change_image(%Image{} = image, attrs \\ %{}) do
    Image.changeset(image, attrs)
  end

  alias Litcovers.Media.Idea

  @doc """
  Returns the list of ideas.

  ## Examples

      iex> list_ideas()
      [%Idea{}, ...]

  """
  def list_ideas do
    Repo.all(Idea)
  end

  @doc """
  Gets a single idea.

  Raises `Ecto.NoResultsError` if the Idea does not exist.

  ## Examples

      iex> get_idea!(123)
      %Idea{}

      iex> get_idea!(456)
      ** (Ecto.NoResultsError)

  """
  def get_idea!(id), do: Repo.get!(Idea, id)

  @doc """
  Creates a idea.

  ## Examples

      iex> create_idea(%{field: value})
      {:ok, %Idea{}}

      iex> create_idea(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_idea(%Image{} = image, attrs \\ %{}) do
    %Idea{}
    |> Idea.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:image, image)
    |> Repo.insert()
  end

  @doc """
  Updates a idea.

  ## Examples

      iex> update_idea(idea, %{field: new_value})
      {:ok, %Idea{}}

      iex> update_idea(idea, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_idea(%Idea{} = idea, attrs) do
    idea
    |> Idea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a idea.

  ## Examples

      iex> delete_idea(idea)
      {:ok, %Idea{}}

      iex> delete_idea(idea)
      {:error, %Ecto.Changeset{}}

  """
  def delete_idea(%Idea{} = idea) do
    Repo.delete(idea)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking idea changes.

  ## Examples

      iex> change_idea(idea)
      %Ecto.Changeset{data: %Idea{}}

  """
  def change_idea(%Idea{} = idea, attrs \\ %{}) do
    Idea.changeset(idea, attrs)
  end
end
