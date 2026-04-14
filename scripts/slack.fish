#!/usr/bin/env fish

set profile_dir "$HOME/.mozilla/firefox-slack-app"

mkdir -p $profile_dir/chrome

printf 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);\n' \
    > $profile_dir/user.js

printf '#navigator-toolbox { display: none !important; }\n' \
    > $profile_dir/chrome/userChrome.css

exec firefox-devedition --profile $profile_dir --no-remote --class SlackApp "https://app.slack.com/"
