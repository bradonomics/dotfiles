#!/bin/bash
# ---------------------------------------------------------------------------
# Copyright 2018, Brad West

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.
# ---------------------------------------------------------------------------


# README:
# This script is used to deploy static HTML/CSS to Github pages
# It allows you to demo the design to stakeholders before writing CMS code


PROGNAME=${0##*/}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  exit 1
}

# TODO: Add warning about branches.

# Check if on gh-pages branch and abort if not.
if [[ $(git rev-parse --abbrev-ref HEAD) != "gh-pages" ]]; then
  error_exit "You should be on the gh-pages branch."
fi

# Merge master into gh-pages
git merge --strategy-option=theirs master || exit

# replace `url("/` in style.css with the github pages url.
sed -i -e 's|url("/|url("https://traveltripperagency.github.io/_template_traveltripper.com/|g' style.css

# grep for `src="/` in index files and add the template name so images and scripts will work in the demo
grep --recursive --files-with-matches 'src="/' --include index.html ./ | xargs sed -i "s|src=\"/|src=\"https://traveltripperagency.github.io/_template_traveltripper.com/|g"

# grep for `srcset="/` in index files and add the template name so images and scripts will work in the demo
grep --recursive --files-with-matches 'srcset="/' --include index.html ./ | xargs sed -i "s|srcset=\"/|srcset=\"https://traveltripperagency.github.io/_template_traveltripper.com/|g"

# grep for `url('/` in index files and add the template name so images and scripts will work in the demo
grep --recursive --files-with-matches "url('/" --include index.html ./ | xargs sed -i "s|url('/|url('https://traveltripperagency.github.io/_template_traveltripper.com/|g"

# grep for `href="/` in index files and add the template name so links will work in the demo
grep --recursive --files-with-matches 'href="/' --include index.html ./ | xargs sed -i "s|href=\"/|href=\"https://traveltripperagency.github.io/_template_traveltripper.com/|g"

# Add files to index and commit
git add . && git commit -m "Deploy changes" --verbose

# Push files to origin
git push

exit
