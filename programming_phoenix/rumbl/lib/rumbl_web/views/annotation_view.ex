defmodule RumblWeb.AnnotationView do
  use RumblWeb, :view
  import Destructure

  def render("annotation.json", d%{annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, RumblWeb.UserView, "user.json")
    }
  end
end
