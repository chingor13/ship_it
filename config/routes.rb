ShipIt::Application.routes.draw do
  resources :projects

  root to: redirect("/projects")
end
