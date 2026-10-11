# VehicleCare — setup guide

VehicleCare is a navy-and-white vehicle maintenance reminder web app. It includes account creation/sign-in, a personal dashboard, reminders, editing/deleting, marking work completed, and service history. Supabase provides real authentication and PostgreSQL storage.

## 1. Create your Supabase backend

1. Visit https://supabase.com/ and create a project.
2. Save the database password somewhere safe.
3. Open **SQL Editor** in your project.
4. Open `supabase-schema.sql`, copy all its contents into the SQL Editor, and click **Run**. This creates the tables and row-level security policies.
5. Open **Project Settings → API** (or **Connect**, depending on dashboard version). Copy the **Project URL** and the **publishable/anon key**. The browser key is intended to be public; never use a `service_role` or secret key in frontend code.

## 2. Connect VehicleCare to Supabase

Open `app.js` and replace these two values near the top:

```js
const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
```

with your project's URL and publishable/anon key. Keep the quotation marks. Do not paste private service-role keys here.

## 3. Run it locally

Because the app uses browser modules/CDN libraries, serve the folder through a local web server rather than opening the HTML file directly.

**Option A — VS Code**
1. Install Visual Studio Code.
2. Open the `vehiclecare` folder.
3. Install the **Live Server** extension.
4. Right-click `index.html` → **Open with Live Server**.

**Option B — Python**
From a terminal in this folder run:

```bash
python -m http.server 8000
```

Then visit http://localhost:8000.

## 4. Configure email confirmation

Supabase may require users to confirm their email address before signing in. In the Supabase dashboard, open **Authentication → URL Configuration** and add your local URL (`http://localhost:8000`) to the allowed redirect URLs. For production, add your deployed website URL too. Use Supabase's email confirmation flow; don't turn off confirmation on a public production site just for convenience.

## 5. Deploy online

You can deploy this static frontend to Netlify, Vercel, or GitHub Pages:
- Upload/push the `vehiclecare` folder to your chosen host.
- Set the deployed website URL in Supabase Authentication URL Configuration.
- Ensure the Supabase URL and publishable/anon key are configured in `app.js`.
- Test sign-up, email confirmation, sign-in, creating reminders, completing a reminder, and logging out.

## Features

- Secure sign-up and sign-in through Supabase Auth (passwords are handled by Supabase, not stored in your app tables).
- Personal data is separated using `user_id` and PostgreSQL Row Level Security.
- Add/edit/delete reminders with vehicle, registration, maintenance task, due date, odometer, estimated cost and notes.
- Dashboard counts total active reminders, due-soon reminders, overdue reminders, and completed services.
- Mark a reminder complete to add a service history entry and record final cost/date.
- Service history with completed date and recorded spending.

## Important limitations / next steps

- Reminders are currently shown in the website dashboard. This starter does **not** send background emails, SMS, push notifications, or calendar alerts. Those require a scheduled backend function (for example Supabase Edge Functions + a scheduled job and an email provider).
- Keep the `service_role` key secret. Only use the publishable/anon key in this frontend.
- The current history flow inserts the history entry and then marks the reminder completed. For a production app, move both operations into a database function/transaction so they always succeed or fail together.
- This is a starter implementation; add CAPTCHA/rate limiting, stronger validation, monitoring, and a privacy policy before public launch.
