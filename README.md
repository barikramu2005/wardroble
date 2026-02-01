# wardroble

👕 Wardrobe

A Personal Smart Clothing Manager

My Wardrobe is a personal wardrobe management application built using Flutter.
It helps track clothes, manage their condition (clean / dirty), organize storage, and suggest outfits intelligently — especially useful for people who struggle with dressing sense.

This is a real-life utility app, not a sample or tutorial project.

🎯 Problem This App Solves

Forgetting which clothes are clean or dirty

Repeating the same outfits unknowingly

Owning clothes with complex colors & patterns that apps don’t understand

No clear idea of what matches with what

Clothes lying unused for long periods

My Wardrobe solves this by mirroring how people actually handle clothes in daily life.

✨ Features
👔 Wardrobe Management

Add clothes with:

Photo

Type (T-shirt, Shirt, Jeans, Trousers, Kurta)

Category (Daily / Casual / Party)

Free-text color & pattern description

View clothes grouped by type

See total count per cloth type

🔄 Cloth State Lifecycle

Each cloth automatically moves through:

READY

NEED WASH

NEED IRON

Usage-based logic:

Shirts / T-shirts → wash after 1 use

Jeans / Trousers → wash after multiple uses

Manual state override is supported.

🧺 Laundry Mode

View all clothes needing wash or ironing

Select multiple clothes

Batch actions:

Mark as washed

Mark as ironed

👕 Outfit Recommendation

Pick any cloth (top or bottom)

Choose an occasion:

Daily

Casual

Party

App suggests a matching outfit

“Try another” option for alternative suggestions

Preference learning:

Tap “I like this 👍”

App remembers your choices and improves future recommendations

No AI, no internet — just practical logic + personal preference learning.

📦 Storage Location Tracking

Track where clean clothes are stored:

Suitcase

Travel Bag

Other

Only READY clothes can be stored

Storage is cleared automatically when clothes become dirty

Wardrobe shows container-wise clothing counts

📊 Insights & Reminders (Planned / In Progress)

Most frequently worn clothes

Clothes not used for long periods

Gentle reminders to rotate unused clothes

🏗️ Tech Stack

Flutter (UI & logic)

Dart

Hive (local persistent storage)

Image Picker (camera integration)

URL Launcher (external links)

The app works completely offline.
