# Rails Session & Cookie Playground

### Understand and experiment with session and cookie storage in Rails 8

👋 A quick demo of how to use cookies and sessions in Rails 8.

## Prerequisites

✅ Rails:

```bash
rails -v
# Rails 8.0.2
```

✅ Ruby:

```bash
ruby -v
# ruby 3.4.4 (2025-05-14 revision a38531fd3f) +PRISM [x86_64-linux]
```

### 🚀 Setup

1️⃣ Create a new Rails app

```bash
rails new session_demo_app
cd session_demo_app
code .
```

2️⃣ Generate controller

```bash
rails generate controller Sessions create show destroy
```

This creates: `app/controllers/sessions_controller.rb`

```ruby
class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    # just render the form
  end

  def create
    username = params[:username]
    token    = params[:token]

    unless token.present?
      render plain: "❌ No token provided", status: :bad_request and return
    end

    cookies[:kc_access_token_plain] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?
    }

    session[:username] = username
    session[:kc_access_token_signed] = token

    redirect_to root_path
    # render plain: "✅ Logged in as #{username}. JWT stored in cookies & session."
  end

  def show
    @username = session[:username]
    @token    = session[:kc_access_token_signed]

    respond_to do |format|
      if @username && @token
        format.html { render :show }
      else
        format.html { render :show, status: :unauthorized }
      end
    end
  end


  def destroy
    reset_session
    cookies.delete(:kc_access_token_plain)
    cookies.delete(:_session_demo_app_session)
    redirect_to root_path, notice: "✅ Logged out. Session & cookies cleared."
  end
end

```

3️⃣ Routes
In config/routes.rb:

```
Rails.application.routes.draw do
  root 'sessions#show'

  get    '/login',  to: 'sessions#new'      # 👈 this shows the form
  post   '/login',  to: 'sessions#create'
  get    '/profile', to: 'sessions#show'
  delete '/logout', to: 'sessions#destroy'
end

```

4️⃣ Start server

```
bin/rails server
```

Visit: http://localhost:3000

5️⃣ Test
Use the provided Jupyter notebook to generate a JWT and send requests.

👉️[Jupyter NB](https://github.com/giljr/my_jupyter_notebook_in_rails/blob/master/session_management_example.ipynb)

✨ That’s it — happy coding!
